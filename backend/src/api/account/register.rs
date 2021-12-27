use rocket::{post, serde::{json::Json, Deserialize}, State, http::{Status, CookieJar, Cookie}};
use crate::{db::{DB, User}, guard::{TOKEN, get_token}};
use mongodb::bson::doc;

#[derive(Deserialize)]
pub struct Req {
    username: String,
    password: String,
}

#[post("/register", data = "<req>")]
pub async fn register(db: &State<DB>, cookie_jar: &CookieJar<'_>, req: Json<Req>) -> Status {
    if db.users.find_one(doc! {"username": &req.username}, None).await.unwrap().is_some() {
        return Status::Conflict;
    }
    let Req { username, password } = req.into_inner();
    let id = db.users.insert_one(User {
        _id: None,
        username,
        password,
    }, None).await.unwrap().inserted_id.as_object_id().unwrap();
    cookie_jar.add_private(Cookie::new(
        TOKEN,
        get_token(id)
    ));
    return Status::Ok;
}
