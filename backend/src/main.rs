use std::time::Duration;
use magic_crypt::{self, new_magic_crypt};
use rocket::{fs::FileServer, Config, routes, fairing::AdHoc, tokio::time::sleep};
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
    secret_key: String,
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
            account::patch,
            account::register,
            account::username,
        ])
        .mount("/", FileServer::from("../web_build"))
        .manage(db::get_db(&args.connection_string).await
            .expect("Can't connect to database."))
        .manage(
            new_magic_crypt!(args.secret_key, 256), // = ase256
        );

    // if debug mode, allow CORS and impose artificial delay
    if args.debug {
        server = server
            .attach(CorsOptions::default().to_cors().unwrap())
            .attach(AdHoc::on_request(
                "Aritficial delay",
                |_, _| Box::pin(sleep(Duration::from_millis(250))),
            ));
    }

    // launch
    server
}
