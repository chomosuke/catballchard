use rocket::{post, serde::{json::Json, Serialize, Deserialize}, State};
use crate::db::{DB, Section, User};

#[derive(Deserialize)]
pub struct Req {
    name: String,
}

#[derive(Serialize)]
pub struct Res {
    id: String,
}

#[post("/", data = "<new>")]
// will automatically 422 if post body doesn't have the right type / parameter etc.
// will 400 if body isn't a good json.
pub async fn post(db: &State<DB>, new: Json<Req>, user: User) -> Json<Res> {
    let id = db.sections.insert_one(Section {
        _id: None,
        name: new.name.clone(),
        user_id: user._id.unwrap(),
    }, None).await.unwrap().inserted_id.as_object_id().unwrap().to_string();
    return Json(Res {
        id,
    })
}