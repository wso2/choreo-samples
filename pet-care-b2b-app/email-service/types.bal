type EmailContent record {|
    EmailType emailType;
    Property[] properties;
    string receipient;
    string emailSubject;
|};

type Property record {|
    string name;
    string value;
|};

enum Type {
    BOOKING_CONFIRMED = "Booking Confirmed",
    VACCINATION_ALERT = "Vaccination Alert"
}

type EmailType BOOKING_CONFIRMED|VACCINATION_ALERT;
