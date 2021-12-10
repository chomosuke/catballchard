use rocket::{get, serde::{json::Json, Serialize}, State};
use crate::db::{DB, User};
use futures::stream::StreamExt;
use mongodb::bson::doc;

#[derive(Serialize)]
pub struct Res {
    ids: Vec<String>,
}

#[get("/all")]
pub async fn all(db: &State<DB>, user: User) -> Json<Res> {
    let mut names = db.names.find(
        doc! { "owner": user._id, },
        None
    ).await.unwrap();
    let mut ids = Vec::new();
    while let Some(name) = names.next().await {
        ids.push(name.unwrap()._id.unwrap().to_string());
    }
    return Json(Res {
        ids,
    });
}
