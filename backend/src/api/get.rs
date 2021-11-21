use mongodb::bson::{oid::ObjectId, doc};
use rocket::{get, serde::{json::Json, Serialize}, State};
use crate::db::DB;

#[derive(Serialize)]
pub struct Res {
    image_url: String,
    name: String,
}

#[get("/<id>")]
pub async fn get(db: &State<DB>, id: &str) -> Option<Json<Res>> {
    let _id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return None;
    };
    let name = db.names.find_one(doc! { "_id": _id }, None).await.unwrap()?;
    return Some(Json(Res {
        image_url: name.image_url,
        name: name.name,
    }));
}
