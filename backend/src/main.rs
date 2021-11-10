#[macro_use] extern crate rocket;
use rocket::fs::FileServer;
use rocket_cors::CorsOptions;
use std::env;

#[get("/hello")]
fn hello() -> &'static str {
    "Hello"
}

#[launch]
fn rocket() -> _ {
    let mut server = rocket::build()
        .mount("/api", routes![hello])
        .mount("/", FileServer::from("../web_build"));
    if env::args().collect::<Vec<String>>().pop().unwrap() == "debug" {
        server = server.attach(CorsOptions::default().to_cors().unwrap());
    }
    server
}
