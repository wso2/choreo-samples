import ballerina/http;
import ballerina/lang.'decimal;

// INFO: Pass an XML such as <invoice><item><name>White Sugar</name><quantity>4</quantity><unit_price>100</unit_price></item>
// <item><name>Wheat Flour</name><quantity>2</quantity><unit_price>200</unit_price></item>
// <item><name>Chicken Egg</name><quantity>2</quantity><unit_price promo-code="free">20</unit_price></item></invoice>
// when invoking this service
service / on new http:Listener(8090) {
    resource function post total(@http:Payload xml invoice) returns xml|error {
        decimal total = 0;
        foreach var item in invoice/<*> {
            xml unitPrice = item/<unit_price>;
            if (unitPrice is xml:Element) {
                string? code = unitPrice.getAttributes()["promo_code"];
                if code == "free" {
                    continue;
                }
            }

            decimal qt = check decimal:fromString((item/<quantity>).data());
            decimal uPrice = check decimal:fromString(unitPrice.data());
            total += qt * uPrice;
        }

        xml result = xml `<grand_total>${total.toString()}</grand_total>`;
        return result;
    }
}
