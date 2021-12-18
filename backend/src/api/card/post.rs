use mongodb::bson::{doc, oid::ObjectId};
use rocket::{post, serde::{json::Json, Serialize, Deserialize}, State, http::Status};
use crate::db::{DB, Card, User, verify_section_id};

#[derive(Deserialize)]
pub struct Req {
    image_url: String,
    description: String,
    section_id: String,
}

#[derive(Serialize)]
pub struct Res {
    id: String,
}

#[post("/", data = "<new>")]
// will automatically 422 if post body doesn't have the right type / parameter etc.
// will 400 if body isn't a good json.
pub async fn post(db: &State<DB>, new: Json<Req>, user: User) -> Result<Json<Res>, Status> {
    let Req { image_url, description, section_id } = new.into_inner();
    
    let section_id = if let Ok(section_id) = ObjectId::parse_str(section_id) {
        section_id
    } else {
        return Err(Status::UnprocessableEntity);
    };

    if !verify_section_id(&section_id, db, &user).await {
        return Err(Status::UnprocessableEntity);
    }

    let id = db.cards.insert_one(Card {
        _id: None,
        image_url,
        description,
        section_id,
    }, None).await.unwrap().inserted_id.as_object_id().unwrap().to_string();
    return Ok(Json(Res {
        id,
    }));
}
