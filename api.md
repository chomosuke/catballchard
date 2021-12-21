- 200 if ok
- 204 if DELETE not found
- 400 if body isn't valid json
- 401 if unauthorized
- 404 if GET/PATCH not found
- 409 if conflict
- 422 if request does not fit schema or if sub entities not found

# CRUD for card

## POST `/card`
- request: cookies
```
{
    image_url: string,
    description: string,
    section_id: string,
}
```
- response:
```
{
    id: string,
}
```

## GET `/card/<id>`
- request: None
- response:
```
{
    image_url: string,
    description: string,
    section_id: string,
}
```

## PATCH `/card/<id>`
- request: cookies
```
{
    image_url?: string,
    description?: string,
    section_id?: string,
}
```
- response: None

## DELETE `/card/<id>`
- request: cookies
- response: None

# CRUD for section

## POST `/section`
- request: cookies
```
{
    name: string,
}
```
- response: 
```
{
    id: string,
}
```

## GET `/section/<id>`
- request: None
- response:
```
{
    name: string,
    card_ids: string[],
}
```

## PATCH `/section/<id>`
- request: cookies
```
{
    name: string
}
```

## DELETE `/section/<id>`
- request: cookies
- response: None

# fetching sections

## GET `/section/all`
- request: None
- response:
```
{
    ids: string[],
}
```

## GET `/section/owned`
- request: cookies
- response:
```
{
    ids: string[],
}
```

# Account management

## POST `/login`
- request:
```
{
    username: string,
    password: string,
}
```
- response: cookies

## POST `/register`
- request:
```
{
    username: string,
    password: string,
}
```
- response: cookies

## POST `/logout`
- request: None
- response: delete cookies

## PATCH `/account`
- request: cookies
```
{
    username?: string,
    password?: string,
}
```
