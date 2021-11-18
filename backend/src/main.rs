#[macro_use] extern crate rocket;
use rocket::fs::FileServer;
use rocket_cors::CorsOptions;
use std::env;
use std::collections::HashMap;

#[get("/hello")]
fn hello() -> &'static str {
    "Hello"
}

#[launch]
fn rocket() -> _ {

    // initialize the server
    let mut server = rocket::build()
        .mount("/api", routes![hello])
        .mount("/", FileServer::from("../web_build"));

    // format the commandline options
    let in_args: Vec<String> = env::args().collect();
    let mut args: HashMap<String, Vec<String>> = HashMap::new();
    let mut current_key: String = String::from("default");
    args.insert(current_key.clone(), Vec::new());
    for in_arg in in_args {
        if in_arg.as_bytes()[0] == '-' as u8 {
            current_key = in_arg;
            args.insert(current_key.clone(), Vec::new());
        } else {
            args.get_mut(&current_key).unwrap().push(in_arg);
        }
    }

    // if -d, run in debug mode which allows CORS
    if args.contains_key("-d") {
        server = server.attach(CorsOptions::default().to_cors().unwrap());
    }

    // launch
    server
}
