use mongodb::bson::{oid::ObjectId, doc};
use rocket::{State, delete, http::Status};
use crate::db::{DB, User};

#[delete("/<id>")]
pub async fn delete(db: &State<DB>, id: &str, user: User) -> Status {
    let _id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return Status::NoContent;
    };

    let name = db.names.find_one(doc! { "_id": _id }, None).await.unwrap();
    if name.is_none() || name.unwrap().owner != user._id.unwrap() {
        return Status::NoContent;
    }

    // result will be unwrapped, so error will panic.
    let result = db.names.delete_one(doc! { "_id": _id }, None).await.unwrap();
    return match result.deleted_count {
        0 => Status::NoContent,
        1 => Status::Ok,
        _ => panic!("Database id collision: Deleted Multiple Names??"),
    }
}
