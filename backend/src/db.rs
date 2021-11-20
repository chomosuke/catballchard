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
    pub names: Collection<Name>,
}

#[derive(Deserialize, Serialize)]
pub struct Name {
    pub _id: ObjectId,
    pub image_url: String,
    pub name: String,
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
            names: db.collection::<Name>("names"),
            db,
        }
    )
}
