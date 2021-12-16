200 if ok
204 if DELETE not found
400 if body isn't valid json
401 if unauthorized
404 if GET/PATCH not found
409 if conflict
422 if request does not fit schema or if sub entities not found

# CURD for card

## POST `/card`
- Authenticated route.
- request:
cookies
```
{
    image_url: string,
    name: string,
    section_id: string,
}
```
- response:
```
{
    id: string,
}
```

## PATCH `/card/<id>`
- Authenticated route.
- request:
cookies
```
{
    image_url?: string,
    name?: string,
    section_id?: string,
}
```
- response: None

## GET `/card/<id>`
- request: none
- response:
```
{
    image_url: string,
    name: string,
    section_id: string,
}
```

## DELETE `/card/<id>`
- Authenticated route.
- request:
cookies
- response: None

# CRD for section (update for section = create/delete for card)

## POST `/section`
- Authenticated route
- request:
cookies
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
- request: none
- response:
```
{
    name: string,
    card_ids: string[],
}
```

## DELETE `/section/<id>`
- request:
cookies
- response: None

# fetching all sections

## GET `/section/all`
- request: none
- response:
```
{
    ids: string[],
}
```

## GET `/section/owned`
- request:
cookies
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
cookies

## POST `/logout`
- request: none
- response:
delete cookies

## PATCH `/account`
- request:
cookies
```
{
    username?: string,
    password?: string,
}
```
