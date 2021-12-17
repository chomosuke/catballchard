use rocket::{patch, serde::{json::Json, Deserialize}, State, http::Status};
use crate::db::{DB, User};
use mongodb::bson::doc;

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
    let update = if let (
        Some(username), Some(password)
    ) = (
        req.username.as_ref(), req.password.as_ref()
    ) {
        doc! { "$set": {
            "username": username,
            "password": password,
        } }
    } else if let Some(username) = req.username.as_ref() {
        doc! { "$set": { "username": username } }
    } else if let Some(password) = req.password.as_ref() {
        doc! { "$set": { "password": password } }
    } else {
        doc! {}
    };

    db.users.update_one(doc! {
            "_id": user._id,
        },
        update,
        None,
    ).await.unwrap();
    return Status::Ok;
}
