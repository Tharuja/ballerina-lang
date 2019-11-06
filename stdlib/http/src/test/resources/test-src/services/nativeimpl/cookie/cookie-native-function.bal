import ballerina/http;

///Tests for session cookies///

// checks domain and path
function testAddCookieToCookieStore1() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample" );
    }
    //get all the cookies
    return cookieStore1.getAllCookies();
 }

//checks domain
 function testAddCookieToCookieStore2() returns @tainted http:Cookie[] {
     http:CookieStore cookieStore1 = new;
     http:Cookie cookie1 = new;
     cookie1.name = "SID002";
     cookie1.value = "239d4dmnmsddd34";
     cookie1.path = "/sample";
     cookie1.domain = "google.com";
     http:Client cookieclientEndpoint = new("http://mail.google.com", { cookieConfig: { enabled: true } } );
     var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
     if (cookieConfigVal is http:CookieConfig) {
         cookieStore1.addCookie(cookie1, cookieConfigVal, "http://mail.google.com", "/sample" );
     }
     //get all the cookies
     return cookieStore1.getAllCookies();
  }
//checks domain

 function testAddCookieToCookieStore3() returns @tainted http:Cookie[] {
     http:CookieStore cookieStore1 = new;
     http:Cookie cookie1 = new;
     cookie1.name = "SID002";
     cookie1.value = "239d4dmnmsddd34";
     cookie1.path = "/sample";
     http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
     var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
     if (cookieConfigVal is http:CookieConfig) {
         cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample" );
     }
     //get all the cookies
     return cookieStore1.getAllCookies();
  }

//checks path
 function testAddCookieToCookieStore4() returns @tainted http:Cookie[] {
     http:CookieStore cookieStore1 = new;
     http:Cookie cookie1 = new;
     cookie1.name = "SID002";
     cookie1.value = "239d4dmnmsddd34";
     cookie1.domain = "google.com";
     http:Client cookieclientEndpoint = new("http://mail.google.com", { cookieConfig: { enabled: true } } );
     var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
     if (cookieConfigVal is http:CookieConfig) {
         cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample" );
     }
     //get all the cookies
     return cookieStore1.getAllCookies();
  }
//checks path
   function testAddCookieToCookieStore5() returns @tainted http:Cookie[] {
       http:CookieStore cookieStore1 = new;
       http:Cookie cookie1 = new;
       cookie1.name = "SID002";
       cookie1.value = "239d4dmnmsddd34";
       cookie1.domain = "google.com";
       cookie1.path = "/mail";
       http:Client cookieclientEndpoint = new("http://mail.google.com", { cookieConfig: { enabled: true } } );
       var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
       if (cookieConfigVal is http:CookieConfig) {
           cookieStore1.addCookie(cookie1, cookieConfigVal, "http://mail.google.com", "/mail/inbox" );
       }
       //get all the cookies
       return cookieStore1.getAllCookies();
    }

function testAddCookiesToCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID001";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Cookie cookie2 = new;
    cookie2.name = "SID002";
    cookie2.value = "239d4dmnmsddd34";
    cookie2.path = "/sample";
    cookie2.domain = "google.com";
    http:Cookie[] cookiesToadd =[cookie1, cookie2];
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookies(cookiesToadd, cookieConfigVal, "http://google.com", "/sample" );
    }
    //get all the cookies
    return cookieStore1.getAllCookies();

 }

//checks path and domain
function testGetCookiesFromCookieStore1() returns @tainted http:Cookie[] {
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
    //get relevant cookie from cookie store
     return cookieStore1.getCookies("http://google.com", "/sample" );
}

//checks domain
function testGetCookiesFromCookieStore2() returns @tainted http:Cookie[] {
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
    //get relevant cookie from cookie store
     return cookieStore1.getCookies("http://mail.google.com", "/sample" );
}

//checks domain
function testGetCookiesFromCookieStore3() returns @tainted http:Cookie[] {
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
     return cookieStore1.getCookies("http://google.com", "/sample" );
}
//check path
function testGetCookiesFromCookieStore4() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/mail";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/mail" );
    }
    //get relevant cookie from cookie store
     return cookieStore1.getCookies("http://google.com", "/mail/inbox" );
}
//check path
function testGetCookiesFromCookieStore5() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    //add cookie
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample" );
    }
    //get relevant cookie from cookie store
     return cookieStore1.getCookies("http://google.com", "/sample" );
}
//check secure
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
   return cookieStore1.getCookies("https://google.com", "/sample" );
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
    boolean isRemoved = cookieStore1.removeCookie("SID002", "google.com", "/sample");
    return cookieStore1.getAllCookies();
}

function testClearAllCookiesInCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore1 = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Cookie cookie2 = new;
    cookie2.name = "SID002";
    cookie2.value = "239d4dmnmsddd34";
    cookie2.path = "/sample";
    cookie2.domain = "google.com";
    http:Cookie[] cookiesToadd =[cookie1, cookie2];
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore1.addCookies(cookiesToadd, cookieConfigVal, "http://google.com", "/sample" );
    }
    //clear all cookies
    cookieStore1.clear();
    return cookieStore1.getAllCookies();

 }