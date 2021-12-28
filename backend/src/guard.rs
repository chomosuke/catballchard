use magic_crypt::{MagicCrypt256, MagicCryptTrait};
use rocket::{
    http::Status,
    request::{Request, FromRequest, Outcome},
    outcome::Outcome::{Failure, Success},
};
use mongodb::bson::{oid::ObjectId, doc};
use std::time::{SystemTime, UNIX_EPOCH};

use crate::db::{DB, User};

const DURATION: u128 = 2629800000; // one month

#[rocket::async_trait]
impl<'r> FromRequest<'r> for User {
    type Error = ();

    async fn from_request(req: &'r Request<'_>) -> Outcome<Self, Self::Error> {
        let magic_crypt = req.rocket().state::<MagicCrypt256>().unwrap();
        let token = req.headers().get_one("Authorization");
        if token.is_none() {
            return Failure((Status::Unauthorized, ()));
        }
        let token = magic_crypt.decrypt_base64_to_string(
            &token.unwrap(),
        );
        if token.is_err() {
            return Failure((Status::Unauthorized, ()));
        }
        let token = token.unwrap();
        let id_time = get_id_time(&token);
        if id_time.is_none() {
            return Failure((Status::Unauthorized, ()));
        }
        let id_time = id_time.unwrap();
        let id = id_time[0];
        let time = id_time[1];
        if time.parse::<u128>().unwrap() < get_time() - DURATION {
            return Failure((Status::Unauthorized, ()));
        }
        let db = req.rocket().state::<DB>().unwrap();
        let user = db.users.find_one(
            doc! { "_id": ObjectId::parse_str(id).unwrap() },
            None
        ).await.unwrap();
        return match user {
            Some(u) => Success(u),
            None => Failure((Status::Unauthorized, ())),
        }
    }
}

fn get_id_time(token: &str) -> Option<Vec<&str>> {
    let id_time = token.split(' ').collect::<Vec<&str>>();
    if id_time.len() != 2 {
        return None;
    } else {
        return Some(id_time);
    }
}

pub fn get_token(user_id: ObjectId, magic_crypt: &MagicCrypt256) -> String {
    let time = get_time();
    return magic_crypt.encrypt_str_to_base64(format!("{} {}", user_id, time));
}

fn get_time() -> u128 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH).unwrap()
        .as_millis()
}
