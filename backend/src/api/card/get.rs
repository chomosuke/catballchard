use mongodb::bson::{doc, oid::ObjectId};
use rocket::{get, serde::{json::Json, Serialize}, State};
use crate::db::DB;

#[derive(Serialize)]
pub struct Res {
    image_url: String,
    description: String,
    section_id: String,
}

#[get("/<id>")]
pub async fn get(db: &State<DB>, id: &str) -> Option<Json<Res>> {
    let id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return None;
    };
    // result will be unwrapped, so error will panic.
    // but option will be forwarded, so if not found -> None 404
    let card = db.cards.find_one(doc! { "_id": id }, None).await.unwrap()?;
    return Some(Json(Res {
        image_url: card.image_url,
        description: card.description,
        section_id: card.section_id.to_string(),
    }));
}
