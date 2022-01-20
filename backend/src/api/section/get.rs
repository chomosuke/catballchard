use mongodb::{bson::{oid::ObjectId, doc}, options::FindOptions};
use rocket::{get, serde::{json::Json, Serialize}, State};
use futures::StreamExt;
use crate::db::DB;

#[derive(Serialize)]
pub struct Res {
    name: String,
    card_ids: Vec<String>,
}

#[get("/<id>")]
pub async fn get(db: &State<DB>, id: &str) -> Option<Json<Res>> {
    let id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return None; // this will return 404
    };

    // result will be unwrapped, so error will panic.
    // but option will be forwarded, so if not found -> None 404
    let section = db.sections.find_one(
        doc! { "_id": id }, None
    ).await.unwrap()?;

    let mut cards = db.cards.find(
        doc! { "section_id": section._id },
        FindOptions::builder().sort(doc! {"order": 1}).build(),
    ).await.unwrap();
    let mut card_ids = Vec::new();
    while let Some(card) = cards.next().await {
        card_ids.push(card.unwrap()._id.unwrap().to_string());
    }

    return Some(Json(Res {
        name: section.name,
        card_ids,
    }));
}
