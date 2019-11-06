import ballerina/http;
import ballerina/log;

@http:ServiceConfig {
    basePath: "/cookie"
}
service cookie on new http:Listener(9253) {

    @http:ResourceConfig {
        methods: ["GET"],
          path: "/addCookiesToResponse"
    }
    resource function addCookies(http:Caller caller, http:Request req) {
    //Create cookies
    http:Cookie cookie1=new;
    cookie1.name="SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/cookie";
    cookie1.domain = "localhost:9253";
    cookie1.httpOnly = true;
    cookie1.secure = false;

    http:Cookie cookie2=new;
    cookie2.name="SID003";
    cookie2.value = "178gd4dmnmsddd34";
    cookie2.path = "/cookie/addCookiesToResponse";
    cookie2.domain = "localhost:9253";
    cookie2.httpOnly = true;
    cookie2.secure = false;

    http:Response res = new;
    //add cookies if there are no cookies in the inbound request, not adding otherwise.
    http:Cookie[] rqstCookies=req.getCookies();
    if(rqstCookies.length() == 0){
        res.addCookie(cookie1);
        res.addCookie(cookie2);
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
        path: "/firstRequest"
    }
    resource function cookieClientFirstRequest(http:Caller caller, http:Request req) {
         http:Client cookieclientEndpoint = new("http://localhost:9253", { cookieConfig: { enabled: true } } );
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
         http:Client cookieclientEndpoint = new("http://localhost:9253", { cookieConfig: { enabled: true } } );
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
         http:Client cookieclientEndpoint = new("http://localhost:9253", { cookieConfig: { enabled: true } } );
        //first request without cookies
        var response1 = cookieclientEndpoint->get("/cookie/addCookiesToResponse", req);

        //remove session Cookie
        boolean isRemoved = cookieclientEndpoint.getCookieStore().removeCookie("SID002", "localhost:9253", "/cookie" );
        //request after removed  one session  cookie
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


    @http:ResourceConfig {
        methods: ["GET"],
          path: "/sendSameSessionCookie"
    }
    resource function sendSameSessionCookie(http:Caller caller, http:Request req) {
    //Create cookies
    http:Cookie cookie1=new;
    cookie1.name="SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/cookie";
    cookie1.domain = "localhost:9253";
    cookie1.httpOnly = true;
    cookie1.secure = false;

    http:Response res = new;
    //add cookies if there are no cookies in the inbound request, not adding otherwise.
    http:Cookie[] rqstCookies=req.getCookies();
    if(rqstCookies.length() == 0){
        res.addCookie(cookie1);
        res.addCookie(cookie1);
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
    path: "/sendIdenticalCookie"
    }
    resource function sendIdenticalCookie(http:Caller caller, http:Request req) {
     http:Client cookieclientEndpoint = new("http://localhost:9253", { cookieConfig: { enabled: true, enablePersistent: true } } );
    //first request without cookies
    var response1 = cookieclientEndpoint->get("/cookie/sendSameSessionCookie", req);
    //second request with cookies
    var response2 = cookieclientEndpoint->get("/cookie/sendSameSessionCookie", req);

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
          path: "/sendMoreCookiesInResponse"
    }
    resource function sendMoreCookiesInResponse(http:Caller caller, http:Request req) {
    //Create cookies
    http:Cookie cookie1=new;
    cookie1.name="SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/cookie";
    cookie1.domain = "localhost:9253";
    cookie1.httpOnly = true;
    cookie1.secure = false;
    http:Cookie cookie2=new;
    cookie2.name="SID003";
    cookie2.value = "178gd4dmnmsddd34";
    cookie2.path = "/cookie/sendMoreCookiesInResponse";
    cookie2.domain = "localhost:9253";
    cookie2.httpOnly = true;
    cookie2.secure = false;

    http:Response res = new;
    //add cookies if there are no cookies in the inbound request, not adding otherwise.
    http:Cookie[] rqstCookies=req.getCookies();
    if(rqstCookies.length() == 0){
        res.addCookie(cookie1);
        var result = caller->respond(res);
            if (result is error) {
                log:printError("Failed to respond to the caller", err = result);
            }
    } else if(rqstCookies.length() == 1) {
        res.addCookie(cookie2);
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
        path: "/addCookieHeaderToThirdRequest"
    }
    resource function addCookieHeaderToThirdRequest(http:Caller caller, http:Request req) {
         http:Client cookieclientEndpoint = new("http://localhost:9253", { cookieConfig: { enabled: true } } );
        //first request without cookies
        var response1 = cookieclientEndpoint->get("/cookie/sendMoreCookiesInResponse", req);
        //second request with one cookie
        var response2 = cookieclientEndpoint->get("/cookie/sendMoreCookiesInResponse", req);
        //third request with adding another cookie
        var response3 = cookieclientEndpoint->get("/cookie/sendMoreCookiesInResponse", req);
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







//server wants to delete a session cookie


    //
    //@http:ResourceConfig {
    //    methods: ["GET"],
    //      path: "/removeCookiesFromRemoteStore"
    //}
    //resource function removeCookiesFromRemoteStore(http:Caller caller, http:Request req) {
    ////Creates a new cookie
    // http:Cookie Cookie1=new;
    // Cookie1.name="SID002";
    // Cookie1.value = "239d4dmnmsddd34";
    // Cookie1.path = "/sample";
    // Cookie1.domain = ".GOOGLE.com.";
    // Cookie1.expires="2017-06-26 05:46:22";
    // Cookie1.httpOnly = true;
    // Cookie1.secure = true;
    //
    // http:Response res = new;
    // // Removes the added cookie from client's cookie store.
    // res.removeCookiesFromRemoteStore(Cookie1);
    // var result = caller->respond(res);
    //}