use rocket::{post, http::{CookieJar, Cookie}};
use crate::guard::TOKEN;

#[post("/logout")]
pub async fn logout(cookie_jar: &CookieJar<'_>) {
    cookie_jar.remove_private(Cookie::named(TOKEN));
}
