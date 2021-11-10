#[macro_use] extern crate rocket;
use rocket::fs::FileServer;

#[get("/hello")]
fn hello() -> &'static str {
    "Hello"
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/api", routes![hello])
        .mount("/", FileServer::from("../web_build"))
}
