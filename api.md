401 if unauthorized

## POST `/add`
- Authenticated route.
- request:
cookies
```
{
    image_url: string,
    name: string,
}
```
- response:
422 if request does not fit schema, 400 if body isn't valid json, 200 if ok.
```
{
    id: string,
}
```

## GET `/<id>`
- Authenticated route.
- request:
cookies
- response:
404 if not found, 200 if ok.
```
{
    image_url: string,
    name: string,
}
```

## DELETE `/<id>`
- Authenticated route.
- request:
cookies
- response: None
204 if not found, 200 if ok.

## GET `/all`
- Authenticated route.
- request:
cookies
- response:
200 if ok.
```
{
    ids: string[],
}
```

## POST `/login`
- request:
```
{
    username: string,
    password: string,
}
```
- response:
cookies

## POST `/register`
- request:
```
{
    username: string,
    password: string,
}
```
- response:
409 if not found, 200 if ok.
cookies
