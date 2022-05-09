// Setter maksimal avstand i meter fra brukerens posisjon til en holdeplass
const DISTANCE = int.fromEnvironment('DISTANCE', defaultValue: 700);

// Setter maksimal tid (i minutter) fremover man kan stoppe busser
const TIME_LIMIT = int.fromEnvironment('TIME_LIMIT', defaultValue: 30);

// Estimert gangfart, utgangspunkt er 1.42m/s
// Brukes for å estimere om man rekker å gå til en buss før
// den er på holdeplassen
var WALKING_SPEED = double.parse(
    const String.fromEnvironment('WALKING_SPEED', defaultValue: '1.42'));

const API_KEY = '8086be631a0b4b5da95cf54513790900';
