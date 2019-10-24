import ballerina/http;
import ballerina/io ;

@http:ServiceConfig {
    basePath: "/cookie"
}
service cookie on new http:Listener(9251) {


    @http:ResourceConfig {
        methods: ["GET"],
          path: "/addCookies"
    }
    resource function addCookies(http:Caller caller, http:Request req) {
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
     res.addCookie(Cookie1);
     var result = caller->respond(res);
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

    //@http:ResourceConfig {
    //    methods: ["GET"],
    //      path: "/getCookies"
    //}
    //resource function getCookies(http:Caller caller, http:Request req) {
    ////Creates a new cookie
    // http:Cookie Cookie1=new;
    // Cookie1.name="SID002";
    // Cookie1.value = "239d4dmnmsddd34";
    // Cookie1.path = "/sample";
    // Cookie1.domain = ".GOOGLE.com.";
    // Cookie1.maxAge = 3600 ;
    // Cookie1.expires="2017-06-26 05:46:22";
    // Cookie1.httpOnly = true;
    // Cookie1.secure = true;
    //
    //http:Response res = new;
    // res.addCookie(Cookie1);
    // var result = caller->respond(res);
    ////Gets the added cookies from response.
    // http:Cookie[] cookiesInResponse=res.getCookies();
    //foreach http:Cookie item in cookiesInResponse {
    //    io:println(item.name);
    // }
    //}


}