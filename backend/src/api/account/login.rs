use magic_crypt::MagicCrypt256;
use rocket::{post, serde::{json::Json, Deserialize, Serialize}, State, http::Status};
use crate::{db::DB, guard::get_token};
use mongodb::bson::doc;

#[derive(Deserialize)]
pub struct Req {
    username: String,
    password: String
}

#[derive(Serialize)]
pub struct Res {
    auth_token: String,
}

#[post("/login", data = "<req>")]
pub async fn login(db: &State<DB>, req: Json<Req>, magic_crypt: &State<MagicCrypt256>) -> Result<Json<Res>, Status> {
    let user = db.users.find_one(doc! {
        "username": &req.username,
        "password": &req.password
    }, None).await.unwrap();
    match user {
        Some(user) => {
            return Ok(Json(Res {
                auth_token: get_token(user._id.unwrap(), magic_crypt.inner())
            }));
        },
        None => return Err(Status::Unauthorized),
    };
}
