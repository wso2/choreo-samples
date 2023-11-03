import ballerina/http;
import ballerina/io;
import ballerinax/edifact.d03a.supplychain.mORDERS;
import ballerinax/edifact.d03a.supplychain.mORDRSP;

public type SupplierRequest record {|
    string buyerName?;
    string date?;
    string productIdentifier;
    int productQty;
    string msgType;
|};

public type SupplierResponse record {|
    string buyerName?;
    string date?;
    boolean isConfirmed;
|};

public type MsgType record {|
    string id;
    string response;
|};

map<MsgType> msgTypes = {
    "ORDERS": {id: "ORDERS", response: "ORDRSP"}
};

service / on new http:Listener(8090) {
    resource function post [string msgTypeId](http:Request req) returns string|error|http:Response {

        // get EDI message from the payload
        string ediMsg = check req.getTextPayload();
        MsgType? msgType = msgTypes[msgTypeId];

        // validation : validate EDI message type
        if msgType is () {
            http:Response response = new;
            response.statusCode = http:STATUS_BAD_REQUEST;
            response.setPayload("Invalid message type");
            return response;
        } else {
            //  transformation and data mapping : process EDI message request
            mORDERS:EDI_ORDERS_Purchase_order_message purchaseOrder = check mORDERS:fromEdiString(ediMsg);
            mORDERS:BEGINNING_OF_MESSAGE_Type beginningOfMessage = purchaseOrder.BEGINNING_OF_MESSAGE;
            mORDERS:DATE_TIME_PERIOD_Type[] dateTimePeriod = purchaseOrder.DATE_TIME_PERIOD;
            mORDERS:Segment_group_1_GType[] references = purchaseOrder.Segment_group_1;
            mORDERS:Segment_group_28_GType qtyData = purchaseOrder.Segment_group_28[0];
            mORDERS:Segment_group_2_GType[] parties = purchaseOrder.Segment_group_2;
            mORDERS:DATE_TIME_PERIOD_Type[] dateTimePeriods = purchaseOrder.DATE_TIME_PERIOD;
            string productIdentifier = qtyData.LINE_ITEM?.ITEM_NUMBER_IDENTIFICATION?.Item_identifier ?: "";
            int productQty = check int:fromString(qtyData.QUANTITY[0].QUANTITY_DETAILS.Quantity);

            string? buyerName = "";
            foreach var party in parties {
                mORDERS:NAME_AND_ADDRESS_Type nameAndAddress = party.NAME_AND_ADDRESS;
                if (nameAndAddress.Party_function_code_qualifier == "BY") {
                    buyerName = nameAndAddress?.PARTY_IDENTIFICATION_DETAILS?.Party_identifier;
                }
            }
            string? orderDate = "";
            foreach var dateTime in dateTimePeriods {
                if (dateTime.DATE_TIME_PERIOD.Date_or_time_or_period_function_code_qualifier == "137") {
                    orderDate = dateTime.DATE_TIME_PERIOD.Date_or_time_or_period_text;
                }
            }

            // data mapping : prepare SupplierRequest object
            SupplierRequest supplierRequest = {
                buyerName: buyerName,
                date: orderDate,
                productIdentifier: productIdentifier,
                productQty: productQty,
                msgType: msgTypeId
            };

            // communicate with the supplier
            io:println("Buyer Request: " + supplierRequest.toString());
            http:Client supplierService = check new ("https://samples.choreoapps.dev/supplier");
            SupplierResponse supplierResponse = check supplierService->post("/", supplierRequest);
            io:println("Supplier Response: " + supplierResponse.toString());

            // transformation and data mapping : process supplier response
            mORDRSP:EDI_ORDRSP_Purchase_order_response_message responseEdiMsg = {
                BEGINNING_OF_MESSAGE: beginningOfMessage,
                DATE_TIME_PERIOD: dateTimePeriod,
                Segment_group_1: references,
                SECTION_CONTROL: {
                    Section_identification: ""
                }
            };

            if (supplierResponse.isConfirmed == true) {
                responseEdiMsg.Segment_group_26 = [
                    {
                        LINE_ITEM: qtyData.LINE_ITEM,
                        QUANTITY: qtyData.QUANTITY,
                        FREE_TEXT: [
                            {
                                Text_subject_code_qualifier: "AAE",
                                TEXT_LITERAL: {
                                    Free_text: "Order is accepted"
                                }
                            }
                        ]
                    }
                ];
            } else {
                responseEdiMsg.Segment_group_26 = [
                    {
                        LINE_ITEM: qtyData.LINE_ITEM,
                        QUANTITY: [], // set quantity empty
                        FREE_TEXT: [
                            {
                                Text_subject_code_qualifier: "AAE",
                                TEXT_LITERAL: {
                                    Free_text: "Order is rejected"
                                }
                            }
                        ]
                    }
                ];
            }

            // transformation : perpare EDI response
            string responseEDI = check mORDRSP:toEdiString(responseEdiMsg);
            // responding to the buyer
            return responseEDI;
        }
    }
}
