## POST `/add`
- request:
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

## DELETE `/<id>`
- request: None
- response: None
204 if not found, 200 if ok.

## GET `/<id>`
- request: None
- response:
404 if not found, 200 if ok.
```
{
    image_url: string,
    name: string,
}
```

## GET `/all`
- request: None
- response:
200 if ok.
```
{
    ids: string[],
}
```
