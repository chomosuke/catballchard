use rocket::{patch, serde::{json::Json, Deserialize}, State, http::Status};
use crate::db::{DB, User, verify_card_id, verify_section_id};
use mongodb::bson::{doc, Document, oid::ObjectId};

#[derive(Deserialize)]
pub struct Req {
    image_url: Option<String>,
    description: Option<String>,
    section_id: Option<String>,
}

#[patch("/<id>", data = "<req>")]
pub async fn patch(db: &State<DB>, id: &str, req: Json<Req>, user: User) -> Status {
    let id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return Status::NotFound;
    };
    if !verify_card_id(&id, db, &user).await {
        return Status::NotFound;
    }

    let Req { image_url, description, section_id } = req.into_inner();
    let section_id = 
    if let Some(section_id) = section_id {
        if let Ok(section_id) = ObjectId::parse_str(section_id) {
            Some(section_id)
        } else {
            return Status::NotFound;
        }
    } else {
        None
    };
    if section_id.is_some() && !verify_section_id(&section_id.as_ref().unwrap(), db, &user).await {
        return Status::UnprocessableEntity;
    }

    // don't update if None, as None update will lead to null username
    let mut update = Document::new();
    if let Some(image_url) = image_url {
        update.insert("image_url", image_url);
    }
    if let Some(description) = description {
        update.insert("description", description);
    }
    if let Some(section_id) = section_id {
        update.insert("section_id", section_id);
    }
    let update = doc! { "$set": update };

    db.users.update_one(
        doc! { "_id": id },
        update,
        None,
    ).await.unwrap();
    return Status::Ok;
}
