use rocket::{get, serde::{json::Json, Serialize}, State};
use crate::db::DB;
use futures::StreamExt;
use mongodb::bson::doc;

#[derive(Serialize)]
pub struct Res {
    ids: Vec<String>,
}

#[get("/all")]
pub async fn all(db: &State<DB>) -> Json<Res> {
    let mut sections = db.sections.find(None, None).await.unwrap();
    let mut ids = Vec::new();
    while let Some(section) = sections.next().await {
        ids.push(section.unwrap()._id.unwrap().to_string());
    }
    return Json(Res {
        ids,
    });
}
