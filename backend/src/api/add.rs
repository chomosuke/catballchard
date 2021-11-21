use mongodb::{bson::oid::ObjectId, error::{ErrorKind, WriteFailure}};
use rocket::{post, serde::{json::Json, Serialize, Deserialize}, State};
use crate::db::{DB, Name};

#[derive(Deserialize)]
pub struct Req {
    image_url: String,
    name: String,
}

#[derive(Serialize)]
pub struct Res {
    id: String,
}

#[post("/add", data = "<new>")]
pub async fn add(db: &State<DB>, new: Json<Req>) -> Json<Res> {
    let id = loop {
        let _id = ObjectId::new();
        let result = db.names.insert_one(Name {
            _id,
            image_url: new.image_url.clone(),
            name: new.name.clone(),
        }, None).await;
        if let Err(e) = &result {
            if let ErrorKind::Write(WriteFailure::WriteError(e)) = &*(e.kind) {
                if e.code == 11000 {
                    println!("id {}, has collided", _id);
                    continue;
                }
            }
        }
        // if result isn't the one that causes continue,
        // either it's Ok(), or it's something that should panick
        result.unwrap();
        break _id.to_string();
    };
    return Json(Res {
        id,
    })
}
