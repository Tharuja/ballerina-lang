import ballerina/http;
import ballerina/log;

@http:ServiceConfig {
    basePath: "/cookie"
}
service cookie on new http:Listener(9251) {

    @http:ResourceConfig {
        methods: ["GET"],
          path: "/addCookiesToResponse"
    }
    resource function addCookies(http:Caller caller, http:Request req) {
    //Create cookies
    http:Cookie Cookie1=new;
    Cookie1.name="SID002";
    Cookie1.value = "239d4dmnmsddd34";
    Cookie1.path = "/cookie";
    Cookie1.domain = "localhost:9251";
    Cookie1.httpOnly = true;
    Cookie1.secure = false;

    http:Cookie Cookie2=new;
    Cookie2.name="SID003";
    Cookie2.value = "178gd4dmnmsddd34";
    Cookie2.path = "/cookie/addCookiesToResponse";
    Cookie2.domain = "localhost:9251";
    Cookie2.httpOnly = true;
    Cookie2.secure = false;

    http:Response res = new;
    //add cookies if there are no cookies in the inbound request, not adding otherwise.
    http:Cookie[] rqstCookies=req.getCookies();
    if(rqstCookies.length() == 0){
        res.addCookie(Cookie1);
        res.addCookie(Cookie2);
        var result = caller->respond(res);
            if (result is error) {
                log:printError("Failed to respond to the caller", err = result);
            }
    } else {
        string cookieHeader = req.getHeader("Cookie");
        var result = caller->respond(<@untainted> cookieHeader);
    }
    }

    @http:ResourceConfig {
        methods: ["GET"],
          path: "/removeCookiesFromRemoteStore"
    }
    resource function removeCookiesFromRemoteStore(http:Caller caller, http:Request req) {
    //Creates a new cookie
     http:Cookie Cookie1=new;
     Cookie1.name="SID002";
     Cookie1.value = "239d4dmnmsddd34";
     Cookie1.path = "/sample";
     Cookie1.domain = ".GOOGLE.com.";
     Cookie1.maxAge = 3600 ;
     Cookie1.expires="2017-06-26 05:46:22";
     Cookie1.httpOnly = true;
     Cookie1.secure = true;

     http:Response res = new;
     // Removes the added cookie from client's cookie store.
     res.removeCookiesFromRemoteStore(Cookie1);
     var result = caller->respond(res);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/firstRequest"
    }
    resource function cookieClientFirstRequest(http:Caller caller, http:Request req) {
         http:Client cookieclientEndpoint = new("http://localhost:9251", { cookieConfig: { enabled: true } } );
        var response = cookieclientEndpoint->get("/cookie/addCookiesToResponse", req);
        if (response is http:Response) {
            var result = caller->respond(response);
            if (result is error) {
                log:printError("Failed to respond to the caller", err = result);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            res.setPayload(response.reason());
            var result = caller->respond(res);
            if (result is error) {
                log:printError("Failed to respond to the caller", err = result);
            }
        }
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/addCookieHeadertoSecondRequest"
    }
    resource function addCookieHeadertoSecondRequest(http:Caller caller, http:Request req) {
         http:Client cookieclientEndpoint = new("http://localhost:9251", { cookieConfig: { enabled: true } } );
        //first request without cookies
        var response1 = cookieclientEndpoint->get("/cookie/addCookiesToResponse", req);
        //second request with cookies
        var response2 = cookieclientEndpoint->get("/cookie/addCookiesToResponse", req);
        if (response2 is http:Response) {
            var result = caller->respond(response2);
            if (result is error) {
                log:printError("Failed to respond to the caller", err = result);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            res.setPayload(response2.reason());
            var result = caller->respond(res);
            if (result is error) {
                log:printError("Failed to respond to the caller", err = result);
            }
        }
    }

       @http:ResourceConfig {
            methods: ["GET"],
            path: "/removeCookieAndRequest"
        }
        resource function removeCookieAndRequest(http:Caller caller, http:Request req) {
             http:Client cookieclientEndpoint = new("http://localhost:9251", { cookieConfig: { enabled: true } } );
            //first request without cookies
            var response1 = cookieclientEndpoint->get("/cookie/addCookiesToResponse", req);

            //remove Cookie
              http:Cookie Cookie1 = cookieclientEndpoint.getCookieStore().getAllCookies()[0];
            cookieclientEndpoint.getCookieStore().removeCookie(Cookie1);
            //request after removed with one cookie
            var response3 = cookieclientEndpoint->get("/cookie/addCookiesToResponse", req);

            if (response3 is http:Response) {
                var result = caller->respond(response3);
                if (result is error) {
                    log:printError("Failed to respond to the caller", err = result);
                }
            } else {
                http:Response res = new;
                res.statusCode = 500;
                res.setPayload(response3.reason());
                var result = caller->respond(res);
                if (result is error) {
                    log:printError("Failed to respond to the caller", err = result);
                }
            }
        }

}

