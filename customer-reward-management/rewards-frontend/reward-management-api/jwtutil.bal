import ballerina/jwt;

// Token validation configs
public configurable string tokenIssuer = ?;
public configurable string jwksEndpoint = ?;

public function validateAndDecodeUserInfo(string jwtToken) returns User|error {
    // Configurations for the JWT issuer with the specified JWKS endpoint
    jwt:ValidatorConfig validatorConfig = check getJWTValidatorConfig();
    // Validate the JWT token
    jwt:Payload decodedData = check jwt:validate(jwtToken, validatorConfig);

    string? firstName = <string>decodedData.get("given_name");
    string? lastName = <string>decodedData.get("family_name");
    string? email = <string>decodedData.get("email");

    return {
        userId: decodedData.sub ?: "",
        firstName: firstName ?: "undefined",
        lastName: lastName ?: "undefined",
        email: email ?: "undefined"
    };

}

function getJWTValidatorConfig() returns jwt:ValidatorConfig|error {
    jwt:ValidatorSignatureConfig signatureConfig = {jwksConfig: {url: jwksEndpoint}};

    jwt:ValidatorConfig validatorConfig = {
        issuer: tokenIssuer,
        signatureConfig: signatureConfig
    };

    return validatorConfig;
}
