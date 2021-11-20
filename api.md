## POST `/add`
- request:
```
{
    image_url: string,
    name: string,
}
```
- response:
```
{
    id: string,
}
```

## GET `/<id>`
- request: None
- response: 
```
{
    image_url: string,
    name: string,
}
```

## GET `/all`
- request: None
- response:
```
{
    ids: string[],
}
```
