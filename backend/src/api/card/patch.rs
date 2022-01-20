use rocket::{patch, serde::{json::Json, Deserialize}, State, http::Status};
use crate::db::{DB, User, get_card, get_section};
use mongodb::bson::{doc, Document, oid::ObjectId};

#[derive(Deserialize)]
pub struct Req {
    image_url: Option<String>,
    description: Option<String>,
    section_id: Option<String>,
    order: Option<String>,
}

#[patch("/<id>", data = "<req>")]
pub async fn patch(db: &State<DB>, id: &str, req: Json<Req>, user: User) -> Status {
    let id = if let Ok(id) = ObjectId::parse_str(id) {
        id
    } else {
        return Status::NotFound;
    };
    if get_card(&id, db, &user).await.is_none() {
        return Status::NotFound;
    }

    let Req {
        image_url,
        description,
        section_id,
        order,
    } = req.into_inner();
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
    if section_id.is_some() && get_section(&section_id.unwrap(), db, &user).await.is_none() {
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
    if let Some(order) = order {
        update.insert("order", order);
    }
    let update = doc! { "$set": update };

    db.cards.update_one(
        doc! { "_id": id },
        update,
        None,
    ).await.unwrap();
    return Status::Ok;
}
