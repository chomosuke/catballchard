use mongodb::bson::{doc, oid::ObjectId};
use rocket::{State, delete, http::Status};
use crate::db::{DB, User, get_card};

#[delete("/<id>")]
pub async fn delete(db: &State<DB>, id: &str, user: User) -> Status {
    let id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return Status::NoContent;
    };
    if get_card(&id, db, &user).await.is_none() {
        return Status::NoContent;
    }

    // result will be unwrapped, so error will panic.
    let result = db.cards.delete_one(doc! { "_id": id }, None).await.unwrap();
    return match result.deleted_count {
        0 => Status::NoContent,
        1 => Status::Ok,
        _ => panic!("Database id collision: Deleted Multiple cards??"),
    }
}
