import ballerina/log;
import ballerinax/kafka;

configurable string groupId = "order-consumers";
configurable string orders = "orders";
configurable string paymentSuccessOrders = "payment-success-orders";
configurable decimal pollingInterval = 1;
configurable string kafkaEndpoint = ?;
configurable string kafkaUsername = ?;
configurable string kafkaPass = ?;


public type Order readonly & record {|
    int id;
    string desc;
    PaymentStatus paymentStatus;
|};

public enum PaymentStatus {
    SUCCESS,
    FAIL
}

final kafka:ConsumerConfiguration consumerConfigs = {
    groupId: groupId,
    topics: [orders],
    offsetReset: kafka:OFFSET_RESET_EARLIEST,
    auth: { username: kafkaUsername, password: kafkaPass },
    sessionTimeout: 45,
    pollingInterval: pollingInterval,
    securityProtocol: kafka:PROTOCOL_SASL_SSL
};

final kafka:ProducerConfiguration producerConfigs = {
    auth: { username: kafkaUsername, password: kafkaPass },
    securityProtocol: kafka:PROTOCOL_SASL_SSL
};

service on new kafka:Listener(kafkaEndpoint, consumerConfigs) {
    private final kafka:Producer orderProducer;

    function init() returns error? {
        self.orderProducer = check new (kafkaEndpoint, producerConfigs);
        log:printInfo("Order consumer service started");
    }

    remote function onConsumerRecord(Order[] orders) returns error? {
        from Order 'order in orders
            where 'order.paymentStatus == SUCCESS
            do {
                log:printInfo("Order received: " + 'order.desc);
                check self.orderProducer->send({
                    topic: paymentSuccessOrders,
                    value: 'order
                });
            };
    }
}
