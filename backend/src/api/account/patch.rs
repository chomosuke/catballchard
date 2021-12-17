use rocket::{patch, serde::{json::Json, Deserialize}, State, http::Status};
use crate::db::{DB, User};
use mongodb::bson::{doc, Document};

#[derive(Deserialize)]
pub struct Req {
    username: Option<String>,
    password: Option<String>,
}

#[patch("/account", data = "<req>")]
pub async fn patch(req: Json<Req>, db: &State<DB>, user: User) -> Status {
    if req.username.is_some()
    && !user.username.eq(req.username.as_ref().unwrap())
    && db.users.find_one(
        doc! {"username": &req.username}, None
    ).await.unwrap().is_some() {
        return Status::Conflict;
    }

    // don't update if None, as None update will lead to null username
    let mut update = Document::new();
    if let Some(username) = req.username.as_ref() {
        update.insert("username", username);
    }
    if let Some(password) = req.password.as_ref() {
        update.insert("password", password);
    }
    let update = doc! { "$set": update };

    db.users.update_one(
        doc! { "_id": user._id },
        update,
        None,
    ).await.unwrap();
    return Status::Ok;
}
