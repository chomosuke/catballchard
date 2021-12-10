use rocket::{post, serde::{json::Json, Serialize, Deserialize}, State};
use crate::db::{DB, Name, User};

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
// will automatically 422 if post body doesn't have the right type / parameter etc.
// will 400 if body isn't a good json.
pub async fn add(db: &State<DB>, new: Json<Req>, user: User) -> Json<Res> {
    let id = db.names.insert_one(Name {
        _id: None,
        image_url: new.image_url.clone(),
        name: new.name.clone(),
        owner: user._id.unwrap(),
    }, None).await.unwrap().inserted_id.as_object_id().unwrap().to_string();
    return Json(Res {
        id,
    })
}
