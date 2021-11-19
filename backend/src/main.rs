use rocket::{fs::FileServer, Config, launch, routes};
use rocket_cors::CorsOptions;
use std::net::IpAddr;
use structopt::StructOpt;

mod api;
use api::*;

#[derive(StructOpt)]
struct Args {
    #[structopt(short, long)]
    debug: bool,

    #[structopt(short, long)]
    port: Option<u16>,

    #[structopt(short, long)]
    address: Option<IpAddr>,
}

#[launch]
fn rocket() -> _ {
    let args = Args::from_args();

    // custom config, default port 80
    let config = Config::figment()
        .merge(("port", args.port.unwrap_or(Config::default().port)))
        .merge(("address", args.address.unwrap_or(Config::default().address)));

    // initialize the server
    let mut server = rocket::custom(config)
        .mount("/api", routes![get_hello])
        .mount("/", FileServer::from("../web_build"));

    // if debug mode, allow CORS
    if args.debug {
        server = server.attach(CorsOptions::default().to_cors().unwrap());
    }

    // launch
    server
}
