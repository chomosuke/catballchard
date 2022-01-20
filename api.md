- 200 if ok
- 204 if DELETE not found
- 400 if body isn't valid json
- 401 if unauthorized
- 404 if GET/PATCH not found
- 409 if conflict
- 422 if request does not fit schema or if sub entities not found

# CRUD for card

## POST `/card`
- request: auth token
```
{
    image_url: string,
    description: string,
    section_id: string,
    order: number,
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
- request: auth token
```
{
    image_url?: string,
    description?: string,
    section_id?: string,
    order?: number,
}
```
- response: None

## DELETE `/card/<id>`
- request: auth token
- response: None

# CRUD for section

## POST `/section`
- request: auth token
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
- request: auth token
```
{
    name: string,
}
```

## DELETE `/section/<id>`
- request: auth token
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
- request: auth token
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
- response:
```
{
    auth_token: string,
}
```

## POST `/register`
- request:
```
{
    username: string,
    password: string,
}
```
- response:
```
{
    auth_token: string,
}
```

## PATCH `/account`
- request: auth token
```
{
    username?: string,
    password?: string,
}
```
- response: None

## GET `/username`
- request: auth token
- response: 
```
{
    username: string,
}
```
