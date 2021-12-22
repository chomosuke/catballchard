use rocket::{get, serde::{json::Json, Serialize}};
use crate::db::User;

#[derive(Serialize)]
pub struct Res {
    username: String,
}

#[get("/username")]
pub async fn username(user: User) -> Json<Res> {
    return Json(Res {
        username: user.username,
    });
}
