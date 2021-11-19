use rocket::get;

#[get("/hello")]
pub fn get_hello() -> &'static str {
    "Hello"
}
