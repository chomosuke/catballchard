use rocket::{fs::FileServer, Config, routes};
use rocket_cors::CorsOptions;
use std::net::IpAddr;
use structopt::StructOpt;
use mongodb::{bson::doc, options::ClientOptions, Client};

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

    #[structopt(short, long)]
    connection_string: String,
}

#[rocket::main]
async fn main() -> Result<(), rocket::Error> {
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

    connect(args.connection_string).await
        .expect(format!("Can't connect to MongoDB database - {}", args.connection_string));

    // launch
    server.launch().await
}

async fn connect(connection_str: String) -> mongodb::error::Result<()> {
    // Parse your connection string into an options struct
    let mut client_options =
        ClientOptions::parse(connection_str)
            .await?;

    // Manually set an option
    client_options.app_name = Some("Rust Demo".to_string());
    // Get a handle to the cluster
    let client = Client::with_options(client_options)?;
    // Ping the server to see if you can connect to the cluster
    client
        .database("admin")
        .run_command(doc! {"ping": 1}, None)
        .await?;
    println!("Connected successfully.");
    // List the names of the databases in that cluster
    for db_name in client.list_database_names(None, None).await? {
        println!("{}", db_name);
    }
    Ok(())
}
