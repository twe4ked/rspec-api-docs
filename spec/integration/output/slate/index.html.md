---
title: API Reference
search: true
---


# Orders


## Creating an order

First, create an order, then make a later request to get it back

```json


```

### HTTP Request

`POST http://example.com/orders`

```json

{
  "email": "email@example.com",
  "name": "Order 1",
  "paid": true
}
```

### HTTP Request

`GET http://example.com/orders/1`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
name | true | Name of order
paid | true | If the order has been paid for
email | false | Email of the user that placed the order

### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
name | string | Name of order
paid | integer | If the order has been paid for
email | string | Email of the user that placed the order

## Viewing an order

Make a request to get an order

```json

{
  "email": "email@example.com",
  "name": "Order 1",
  "paid": true
}
```

### HTTP Request

`GET http://example.com/orders/1`


### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
name | string | Name of order
paid | integer | If the order has been paid for
email | string | Email of the user that placed the order

## Deleting an order

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Qui est in parvis malis.

Duo Reges: constructio interrete. Luxuriam non reprehendit, modo sit vacua infinita cupiditate et timore. Non enim iam stirpis bonum quaeret, sed animalis.

Haec quo modo conveniant, non sane intellego. Verum hoc idem saepe faciamus. Nihilo beatiorem esse Metellum quam Regulum.


```json

{
  "email": "email@example.com",
  "name": "Order 1",
  "paid": true
}
```

### HTTP Request

`GET http://example.com/orders/1`



# Characters


## Returns a Character

For getting information about a Character.

```json

{
  "id": "1",
  "name": "Character 1"
}
```

### HTTP Request

`GET http://example.com/characters/1`


### Response Fields

Parameter | Type | Description
--------- | ------- | -----------
id | integer | The id of a character
name | string | The character's name
