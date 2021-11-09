#[macro_use] extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    return "Hello, world!";
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index])
}
