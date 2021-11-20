## POST `/add`
- request:
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

## GET `/<id>`
- request: None
- response: 
```
{
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
