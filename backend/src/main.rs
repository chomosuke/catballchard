use rocket::{fs::FileServer, Config, routes};
use rocket_cors::CorsOptions;
use std::net::IpAddr;
use structopt::StructOpt;
use api::*;

mod db;
mod api;
mod guard;

#[derive(StructOpt)]
struct Args {
    #[structopt(short, long)]
    debug: bool,

    #[structopt(short, long)]
    port: Option<u16>,

    #[structopt(short, long)]
    address: Option<IpAddr>,

    #[structopt(short, long)]
    connection_string: String,

    #[structopt(short, long)]
    secret_key: Option<String>,
}

#[rocket::launch]
async fn rocket() -> _ {
    let args = Args::from_args();

    // custom config, default port 80
    let mut config = Config::figment();
    if args.port.is_some() {
        config = config.merge(("port", args.port.unwrap()));
    }
    if args.address.is_some() {
        config = config.merge(("address", args.address.unwrap()));
    }
    if args.secret_key.is_some() {
        config = config.merge(("secret_key", args.secret_key.unwrap()))
    }

    // initialize the server
    let mut server = rocket::custom(config)
        .mount("/api/card", routes![
            card::delete,
            card::get,
            card::patch,
            card::post,
        ])
        .mount("/api/section", routes![
            section::all,
            section::delete,
            section::get,
            section::owned,
            section::patch,
            section::post,
        ])
        .mount("/api", routes![
            account::login,
            account::logout,
            account::patch,
            account::register,
        ])
        .mount("/", FileServer::from("../web_build"))
        .manage(db::get_db(&args.connection_string).await
            .expect("Can't connect to database."));

    // if debug mode, allow CORS
    if args.debug {
        server = server.attach(CorsOptions::default().to_cors().unwrap());
    }

    // launch
    server
}
