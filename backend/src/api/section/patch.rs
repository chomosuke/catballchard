use rocket::{patch, serde::{json::Json, Deserialize}, State, http::Status};
use crate::db::{DB, User, get_section};
use mongodb::bson::{doc, oid::ObjectId};

#[derive(Deserialize)]
pub struct Req {
    name: String,
}

#[patch("/<id>", data = "<req>")]
pub async fn patch(db: &State<DB>, id: &str, req: Json<Req>, user: User) -> Status {
    let id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return Status::NotFound;
    };
    if get_section(&id, db, &user).await.is_some() {
        return Status::NotFound;
    }

    println!("{}", &req.name);
    db.sections.update_one(
        doc! { "_id": id },
        doc! { "$set": { "name": req.into_inner().name } },
        None,
    ).await.unwrap();
    return Status::Ok;
}
