Documentation
In order to create an order you have to follow the nect body
{
    "order": {
        "waiter_id": 3,
        "table_id": 1,
        "items": [
            {"product_id": 1, "quantity": 4},
            {"product_id": 2, "quantity": 8},
            {"product_id": 3, "quantity": 2}
        ]
    }
}

You need to send this to this url http://localhost:3000/orders
