use rocket::{post, serde::{json::Json, Deserialize}, State, http::{Status, CookieJar, Cookie}};
use crate::{db::DB, guard::{TOKEN, get_token}};
use mongodb::bson::doc;

#[derive(Deserialize)]
pub struct Req {
    username: String,
    password: String
}

#[post("/login", data = "<req>")]
pub async fn login(db: &State<DB>, cookie_jar: &CookieJar<'_>, req: Json<Req>) -> Status {
    let user = db.users.find_one(doc! {
        "username": &req.username,
        "password": &req.password
    }, None).await.unwrap();
    match user {
        Some(user) => {
            cookie_jar.add_private(Cookie::new(
                TOKEN, 
                get_token(user._id.unwrap())
            ));
            return Status::Ok;
        },
        None => return Status::Unauthorized,
    };

}
