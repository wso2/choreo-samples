# Flask Application for a Restaurant Reservation System

This is a simple Flask application developed to demonstrate a restaurant reservation system. The application is developed using Python 3.9.7 and Flask 2.0.2.

## Deploying the application in Choreo
1. Fork this repository.
2. Create a `Service` component in Choreo.
3. Deploy the component.

## Testing the application

Invoke the following endpoints to test the application. Make sure to change the `<endpoint-url>` to the URL of the deployed component.

### Viewing all the available resevations

```
curl -X GET <endpoint-url>/reservations


[{"reservationCreator": "John Doe", "reservationId": "1234", "contact": "011-123-4567"}, {"reservationCreator": "Jane Doe", "reservationId": "5678", "contact": "011-123-4562"}, {"reservationCreator": "John Smith", "reservationId": "9012", "contact": "011-123-4523"}]
```

### Viewing a specific resevation

```
curl -X GET <endpoint-url>/reservation/1234

Your reservation details: {"reservationCreator": "John Doe", "reservationId": "1234", "contact": "011-123-4567"}

```

### Adding a resevation

```
curl -X POST -d '{"reservationCreator": "John Doe", "reservationId": "111", "contact": "011-123-1111"}' <endpoint-url>/reservation/1111


Your added reservation details: b'{"reservationCreator": "John Doe", "reservationId": "111", "contact": "011-123-1111"}'
```

### Updating a resevation

```
curl -X PUT <endpoint-url>/reservation/1234 -d '{"reservationCreator": "Lahiru C", "reservationId": "1234", "contact": "011-123-4588"}' 

Reservation updated: 1234
```

### Deleting a resevation

```
curl -X DELETE <endpoint-url>/reservation/1234

Reservation deleted: {"reservationCreator": "John Doe", "reservationId": "1234", "contact": "011-123-4567"}

```
