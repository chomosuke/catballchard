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
}

#[derive(Deserialize, Serialize)]
pub struct Section {
    #[serde(skip_serializing_if="Option::is_none")]
    pub _id: Option<ObjectId>,
    pub name: String,
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
