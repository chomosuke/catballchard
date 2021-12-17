use futures::StreamExt;
use rocket::{get, serde::{json::Json, Serialize}, State};
use crate::db::{DB, User};
use mongodb::bson::doc;

#[derive(Serialize)]
pub struct Res {
    ids: Vec<String>,
}

#[get("/owned")]
pub async fn owned(db: &State<DB>, user: User) -> Json<Res> {
    let mut sections = db.sections.find(
        doc! { "user_id": user._id, },
        None
    ).await.unwrap();
    let mut ids = Vec::new();
    while let Some(section) = sections.next().await {
        ids.push(section.unwrap()._id.unwrap().to_string());
    }
    return Json(Res {
        ids,
    });
}