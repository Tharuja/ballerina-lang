// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

// Tests for session cookies.
function testAddCookieToCookieStore1() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
    // Gets all the cookies.
    return cookieStore.getAllCookies();
}

function testAddCookieToCookieStore2() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://mail.google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://mail.google.com", "/sample");
    }
    return cookieStore.getAllCookies();
}

function testAddCookieToCookieStore3() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
    return cookieStore.getAllCookies();
}

function testAddCookieToCookieStore4() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://mail.google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
    return cookieStore.getAllCookies();
}

function testAddCookieToCookieStore5() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.domain = "google.com";
    cookie1.path = "/mail";
    http:Client cookieclientEndpoint = new("http://mail.google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
       cookieStore.addCookie(cookie1, cookieConfigVal, "http://mail.google.com", "/mail/inbox");
    }
    return cookieStore.getAllCookies();
}

function testAddCookiesToCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
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
        cookieStore.addCookies(cookiesToadd, cookieConfigVal, "http://google.com", "/sample");
    }
    return cookieStore.getAllCookies();
}

function testAddSimilarCookieToCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    cookie1.httpOnly = true;
    http:Cookie cookie2 = new;
    cookie2.name = "SID002";
    cookie2.value = "6789mnmsddd34";
    cookie2.path = "/sample";
    cookie2.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
        cookieStore.addCookie(cookie2, cookieConfigVal, "http://google.com", "/sample");
    }
    return cookieStore.getAllCookies();
}

function testGetCookiesFromCookieStore1() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    // Adds cookie.
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
    // Gets relevant cookie from cookie store.
     return cookieStore.getCookies("http://google.com", "/sample");
}

function testGetCookiesFromCookieStore2() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
     return cookieStore.getCookies("http://mail.google.com", "/sample");
}

function testGetCookiesFromCookieStore3() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
     return cookieStore.getCookies("http://google.com", "/sample");
}

function testGetCookiesFromCookieStore4() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/mail";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/mail");
    }
     return cookieStore.getCookies("http://google.com", "/mail/inbox");
}

function testGetCookiesFromCookieStore5() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
     return cookieStore.getCookies("http://google.com", "/sample");
}

function testGetSecureCookieFromCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    cookie1.secure = true;
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
   return cookieStore.getCookies("https://google.com", "/sample");
}

function testRemoveCookieFromCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
    http:Cookie cookie1 = new;
    cookie1.name = "SID002";
    cookie1.value = "239d4dmnmsddd34";
    cookie1.path = "/sample";
    cookie1.domain = "google.com";
    http:Client cookieclientEndpoint = new("http://google.com", { cookieConfig: { enabled: true } } );
    var cookieConfigVal = cookieclientEndpoint.config.cookieConfig;
    if (cookieConfigVal is http:CookieConfig) {
        cookieStore.addCookie(cookie1, cookieConfigVal, "http://google.com", "/sample");
    }
    boolean isRemoved = cookieStore.removeCookie("SID002", "google.com", "/sample");
    return cookieStore.getAllCookies();
}

function testClearAllCookiesInCookieStore() returns @tainted http:Cookie[] {
    http:CookieStore cookieStore = new;
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
        cookieStore.addCookies(cookiesToadd, cookieConfigVal, "http://google.com", "/sample");
    }
    cookieStore.clear();
    return cookieStore.getAllCookies();
}
