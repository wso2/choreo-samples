import ballerina/log;
import ballerinax/aayu.mftg.as2 as mftgClient;
import ballerinax/trigger.aayu.mftg.as2 as mftgTrigger;

@display {label: "Sender's AS2 Identifier", description: "AS2 identifier of sender"}
configurable string as2From = ?;
@display {label: "MFT Gateway Username", description: "Username of MFT gateway account"}
configurable string username = ?;
@display {label: "MFT Gateway Password", description: "Password of MFT gateway account"}
configurable string password = ?;

listener mftgTrigger:Listener webhookListener =  new;

@display {label: "MFTG New Message to MFTG client"}
service mftgTrigger:ReceivedMessageService on webhookListener {
    remote function onMessageReceivedSuccess(mftgTrigger:MessageReceivedEvent event) returns error? {
        mftgClient:Client mftgClient = check new (username, password, as2From);
        mftgClient:ResponseWithMessage responseWithMessage = check mftgClient->markReceivedMessageAsUnRead(event.messageAS2ID);
        log:printInfo(string `Marked received message as unread : ${responseWithMessage.message}`);
    }
}
