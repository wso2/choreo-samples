package io.swagger.petstore.controller;

import io.swagger.oas.inflector.models.RequestContext;
import io.swagger.oas.inflector.models.ResponseContext;
import io.swagger.petstore.data.UserData;
import io.swagger.petstore.model.User;
import io.swagger.petstore.utils.Util;
import org.apache.commons.lang.math.RandomUtils;

import javax.ws.rs.core.Response;
import java.util.Date;

@javax.annotation.Generated(value = "class io.swagger.codegen.languages.JavaInflectorServerCodegen", date = "2017-04-08T15:48:56.501Z")
public class UserController {

    private static UserData userData = new UserData();

    public ResponseContext createUser(final RequestContext request, final User user) {
        if (user == null) {
            return new ResponseContext()
                    .status(Response.Status.BAD_REQUEST)
                    .entity("No User provided. Try again?");
        }

        userData.addUser(user);
        return new ResponseContext()
                .contentType(Util.getMediaType(request))
                .entity(user);
    }

    public ResponseContext getUserByName(final RequestContext request, final String username) {
        if (username == null) {
            return new ResponseContext()
                    .status(Response.Status.BAD_REQUEST)
                    .entity("No username provided. Try again?");
        }

        final User user = userData.findUserByName(username);
        if (user == null) {
            return new ResponseContext().status(Response.Status.NOT_FOUND).entity("User not found");
        }

        return new ResponseContext()
                .contentType(Util.getMediaType(request))
                .entity(user);
    }
}
