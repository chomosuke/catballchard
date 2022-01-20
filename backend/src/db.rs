use mongodb::{
    bson::doc,
    bson::oid::ObjectId,
    options::ClientOptions,
    Client,
    Database,
    Collection
};
use serde::{Deserialize, Serialize};

pub struct DB {
    pub db: Database,
    pub cards: Collection<Card>,
    pub sections: Collection<Section>,
    pub users: Collection<User>,
}

#[derive(Deserialize, Serialize)]
pub struct Card {
    #[serde(skip_serializing_if="Option::is_none")]
    pub _id: Option<ObjectId>,
    pub image_url: String,
    pub description: String,
    pub section_id: ObjectId,
    pub order: i32,
}

pub async fn get_card(card_id: &ObjectId, db: &DB, user: &User) -> Option<Card> {
    let card = db.cards.find_one(doc! { "_id": card_id }, None).await.unwrap();
    if card.is_none() {
        return None;
    }
    let card = card.unwrap();
    let section = db.sections.find_one(doc! { "_id": card.section_id }, None)
        .await.unwrap().expect(&format!("orphanded card, id: {}", &card._id.unwrap().to_string()));
    if section.user_id != user._id.unwrap() {
        return None;
    }
    return Some(card);
}

#[derive(Deserialize, Serialize)]
pub struct Section {
    #[serde(skip_serializing_if="Option::is_none")]
    pub _id: Option<ObjectId>,
    pub name: String,
    pub user_id: ObjectId,
}

pub async fn get_section(section_id: &ObjectId, db: &DB, user: &User) -> Option<Section> {
    let section = db.sections.find_one(
        doc! {
            "_id": section_id,
            "user_id": user._id.unwrap(),
        },
        None,
    ).await.unwrap();
    return section;
}

#[derive(Deserialize, Serialize)]
pub struct User {
    #[serde(skip_serializing_if="Option::is_none")]
    pub _id: Option<ObjectId>,
    pub username: String,
    pub password: String,
}

pub async fn get_db(connection_str: &str) -> mongodb::error::Result<DB> {
    // Parse your connection string into an options struct
    let mut client_options = ClientOptions::parse(connection_str).await?;

    // Manually set an option
    client_options.app_name = Some("CatBallChard".to_string());

    // Get a handle to the database
    let db = Client::with_options(client_options)?.database("catballchard");

    // Ping the server to see if you can connect to the cluster
    db.run_command(doc! {"ping": 1}, None)
        .await?;
    println!("Connected to database successfully.");

    Ok(
        DB {
            cards: db.collection::<Card>("cards"),
            sections: db.collection::<Section>("sections"),
            users: db.collection::<User>("users"),
            db,
        }
    )
}
