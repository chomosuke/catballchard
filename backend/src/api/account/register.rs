use magic_crypt::MagicCrypt256;
use rocket::{post, serde::{json::Json, Deserialize, Serialize}, State, http::Status};
use crate::{db::{DB, User}, guard::get_token};
use mongodb::bson::doc;

#[derive(Deserialize)]
pub struct Req {
    username: String,
    password: String,
}

#[derive(Serialize)]
pub struct Res {
    auth_token: String,
}

#[post("/register", data = "<req>")]
pub async fn register(db: &State<DB>, req: Json<Req>, magic_crypt: &State<MagicCrypt256>) -> Result<Json<Res>, Status> {
    if db.users.find_one(doc! {"username": &req.username}, None).await.unwrap().is_some() {
        return Err(Status::Conflict);
    }
    let Req { username, password } = req.into_inner();
    let id = db.users.insert_one(User {
        _id: None,
        username,
        password,
    }, None).await.unwrap().inserted_id.as_object_id().unwrap();
    return Ok(Json(Res {
        auth_token: get_token(id, magic_crypt.inner()),
    }));
}
