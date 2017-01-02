---
title: API Reference
search: true
---


# Characters


## Listing all characters

Getting all the characters.

For when you need everything!


```json

{
  "data": [
    {
      "id": 1,
      "name": "Finn the Human"
    },
    {
      "id": 2,
      "name": "Jake the Dog"
    }
  ]
}
```

### HTTP Request

`GET http://example.com/characters`


### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
id | integer | The id of a character
name | string | The character's name

## Fetching a Character

For getting information about a Character.

```json

{
  "character": {
    "id": 1,
    "name": "Finn the Human"
  }
}
```

### HTTP Request

`GET http://example.com/characters/1`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
id | true | The id of a character

### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
id | integer | The id of a character
name | string | The character's name

## When a Character cannot be found

Returns an error

```json

{
  "errors": {
    "message": "Character not found."
  }
}
```

### HTTP Request

`GET http://example.com/characters/404`


### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
message | string | Error message

## Deleting a Character

For getting information about a Character.

```json

{
  "message": "Character not found."
}
```

### HTTP Request

`DELETE http://example.com/characters/1`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
id | true | The id of a character

### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
message | string | Success message

## Characters head



```json


```

### HTTP Request

`HEAD http://example.com/characters`



# Places


## Listing all places



```json

{
  "data": [
    {
      "id": 1,
      "name": "Candy Kingdom"
    },
    {
      "id": 2,
      "name": "Tree Fort"
    }
  ]
}
```

### HTTP Request

`GET http://example.com/places`


### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
id | integer | The id of the place
name | string | The place's name

## Fetching all places and page 2



```json

{
  "data": [
    {
      "id": 1,
      "name": "Candy Kingdom"
    },
    {
      "id": 2,
      "name": "Tree Fort"
    }
  ]
}
```

### HTTP Request

`GET http://example.com/places`

```json

{
  "data": [

  ]
}
```

### HTTP Request

`GET http://example.com/places?page=2`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
page | false | The page

### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
id | integer | The id of the place
name | string | The place's name
