use rocket::{get, serde::{json::Json, Serialize}, State};
use super::super::db::DB;
use futures::stream::StreamExt;

#[derive(Serialize)]
pub struct All {
    ids: Vec<String>,
}

#[get("/all")]
pub async fn all(db: &State<DB>) -> Json<All> {
    let mut names = db.names.find(None, None).await.unwrap();
    let mut ids = Vec::new();
    while let Some(name) = names.next().await {
        ids.push(name.unwrap()._id.to_string());
    }
    Json(All {
        ids,
    })
}
