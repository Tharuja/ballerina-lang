import ballerina/http;

//session cookies
function testAddCookieWithUnmatchedDomain() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "foo.example.com";
    http:Client cookieclientEndpoint = new("http://bar.example.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://bar.example.com", "/sample" );
    }
    //get all the cookies
    return cookieStore1.getAllCookies();

 }


function testAddCookieWithUnmatchedPath() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/mail/inbox";
    cookie1.domain = "example.com";
    http:Client cookieclientEndpoint = new("http://example.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://example.com", "/mail" );
    }
    //get all the cookies
    return cookieStore1.getAllCookies();

 }


function testGetSecureCookieFromCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    cookie1.secure = true;
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample" );
    }
    //get relevant cookie from cookie store
   return cookieStore1.getCookies("http://google.com", "/sample" );
}

function testGetHttpOnlyCookieFromCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    cookie1.httpOnly = true;
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample" );
    }
    //get relevant cookie from cookie store
   return cookieStore1.getCookies("google.com", "/sample" );
}

function testGetCookieToUnmatchedDomain1() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample" );
    }
    //get relevant cookie from cookie store
   return cookieStore1.getCookies("http://mail.google.com", "/sample" );
}


function testGetCookieToUnmatchedDomain2() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "foo.google.com";
    http:Client cookieclientEndpoint = new("http://foo.google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://foo.google.com", "/sample" );
    }
    //get relevant cookie from cookie store
   return cookieStore1.getCookies("http://google.com", "/sample" );
}

function testGetCookieToUnmatchedPath1() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/mail/inbox";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/mail/inbox" );
    }
    //get relevant cookie from cookie store
   return cookieStore1.getCookies("http://google.com", "/mail" );
}

function testGetCookieToUnmatchedPath2() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/mail" );
    }
    //get relevant cookie from cookie store
   return cookieStore1.getCookies("http://google.com", "/sample" );
}

function testRemoveCookieFromCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample" );
    }
    //remove this cookie
    boolean isRemoved = cookieStore1.removeCookie("SID003", "google.com", "/sample");
    return cookieStore1.getAllCookies();
}