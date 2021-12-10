use mongodb::bson::{oid::ObjectId, doc};
use rocket::{get, serde::{json::Json, Serialize}, State};
use crate::db::{DB, User};

#[derive(Serialize)]
pub struct Res {
    image_url: String,
    name: String,
}

#[get("/<id>")]
pub async fn get(db: &State<DB>, id: &str, user: User) -> Option<Json<Res>> {
    let _id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return None; // this will return 404
    };

    // result will be unwrapped, so error will panic.
    // but option will be forwarded, so if not found -> None 404
    let name = db.names.find_one(doc! { "_id": _id }, None).await.unwrap()?;
    if name.owner != user._id.unwrap() {
         return None;
    }
    return Some(Json(Res {
        image_url: name.image_url,
        name: name.name,
    }));
}
