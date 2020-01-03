// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/time;
import ballerina/stringutils;
import ballerina/log;
import ballerina/io;
import ballerina/file;

# Represents the cookie store.
#
# + allSessionCookies - Array to store all the session cookies
# + persistentCookieHandler - Persistent cookie handler to manage persistent cookies
public type CookieStore object {

    Cookie[] allSessionCookies = [];
    PersistentCookieHandler persistentCookieHandler;

    public function __init(PersistentCookieHandler persistentCookieHandler) {
            self.persistentCookieHandler = persistentCookieHandler;
    }

    # Adds a cookie to the cookie store according to the rules in [RFC-6265](https://tools.ietf.org/html/rfc6265#section-5.3).
    #
    # + cookie - Cookie to be added
    # + cookieConfig - Configurations associated with the cookies
    # + url - Target service URL
    # + requestPath - Resource path
    public function addCookie(Cookie cookie, CookieConfig cookieConfig, string url, string requestPath) {
        string domain = getDomain(url);
        if (isDomainBlocked(domain)) {
            return;
        }
        string path  = requestPath;
        int? index = requestPath.indexOf("?");
        if (index is int) {
            path = requestPath.substring(0,index);
        }
        lock {
            Cookie? identicalCookie = getIdenticalCookie(cookie, self);
            if (!isDomainMatched(cookie, domain, cookieConfig)) {
                return;
            }
            if (!isPathMatched(cookie, path, cookieConfig)) {
                return;
            }
            if (!isExpiresAttributeValid(cookie)) {
                return;
            }
            if (!((url.startsWith(HTTP) && cookie.httpOnly) || cookie.httpOnly == false)) {
                return;
            }
            if (cookie.isPersistent()) {
                if (!cookieConfig.enablePersistence) {
                    return;
                }
                addPersistentCookie(identicalCookie, cookie, url, self);
            } else {
                addSessionCookie(identicalCookie, cookie, url, self);
            }
        }
    }

    # Adds an array of cookies.
    #
    # + cookiesInResponse - Cookies to be added
    # + cookieConfig - Configurations associated with the cookies
    # + url - Target service URL
    # + requestPath - Resource path
    public function addCookies(Cookie[] cookiesInResponse, CookieConfig cookieConfig, string url, string requestPath) {
        foreach var cookie in cookiesInResponse {
            self.addCookie(cookie, cookieConfig, url, requestPath);
        }
    }

    # Gets the relevant cookies for the given URL and the path according to the rules in [RFC-6265](https://tools.ietf.org/html/rfc6265#section-5.4).
    #
    # + url - URL of the request URI
    # + requestPath - Path of the request URI
    # + return - Array of the matched cookies stored in the cookie store
    public function getCookies(string url, string requestPath) returns Cookie[] {
        Cookie[] cookiesToReturn = [];
        string domain = getDomain(url);
        if (isDomainBlocked(domain)) {
            return cookiesToReturn;
        }
        string path  = requestPath;
        int? index = requestPath.indexOf("?");
        if (index is int) {
            path = requestPath.substring(0,index);
        }
        Cookie[] allCookies = self.getAllCookies();
        lock {
            foreach var cookie in allCookies {
                if (isExpired(cookie)) {
                    continue;
                }
                if (!((url.startsWith(HTTPS) && cookie.secure) || cookie.secure == false)) {
                    return cookiesToReturn;
                }
                if (!((url.startsWith(HTTP) && cookie.httpOnly) || cookie.httpOnly == false)) {
                    return cookiesToReturn;
                }
                if (cookie.hostOnly == true) {
                    if (cookie.domain == domain && checkPath(path, cookie)) {
                        cookiesToReturn.push(cookie);
                    }
                } else {
                    var temp = cookie.domain;
                    if (((temp is string && domain.endsWith("." + temp)) || cookie.domain == domain ) && checkPath(path, cookie)) {
                        cookiesToReturn.push(cookie);
                    }
                }
            }
             // TODO:Get persistent cookies from database. check expires
            return cookiesToReturn;
        }
    }

    # Gets all the cookies in the cookie store.
    #
    # + return - Array of all the cookie objects
    public function getAllCookies() returns Cookie[] {
        // TODO:Get persistent cookies.
        Cookie[] allCookies = [];
        foreach var cookie in self.allSessionCookies {
            allCookies.push(cookie);
        }
        Cookie[] persistentCookies = self.persistentCookieHandler.getCookies();
        foreach var cookie in persistentCookies {
            allCookies.push(cookie);
        }
        return allCookies;
    }

    # Removes a specific cookie.
    #
    # + name - Name of the cookie to be removed
    # + domain - Domain of the cookie to be removed
    # + path - Path of the cookie to be removed
    # + return - Return true if the relevant cookie is removed, false otherwise
    public function removeCookie(string name, string domain, string path) returns boolean {
         lock {
             // Removes the session cookie in the cookie store, which is matched with the given name, domain and path.
             int k = 0;
             while (k < self.allSessionCookies.length()) {
                 if (name == self.allSessionCookies[k].name && domain == self.allSessionCookies[k].domain && path ==  self.allSessionCookies[k].path) {
                     int j = k;
                     while (j < self.allSessionCookies.length()-1) {
                         self.allSessionCookies[j] = self.allSessionCookies[j + 1];
                         j = j + 1;
                     }
                     _ = self.allSessionCookies.pop();
                     return true;
                 }
                 k = k + 1;
             }
             // TODO:Remove from the database if it is a persistent cookie.
             return self.persistentCookieHandler.removeCookie(name, domain, path);
         }
    }

    # Removes cookies which match with the given domain.
    #
    # + domain - Domain of the cookie to be removed
    public function removeCookieByDomain(string domain) {
        Cookie[] allCookies = self.getAllCookies();
        string? temp1 = ();
        string? temp2 = ();
        lock {
            foreach var cookie in allCookies {
                if (cookie.domain == domain ) {
                    temp1 = cookie.name;
                    temp2 = cookie.path;
                    if (temp1 is string && temp2 is string) {
                        _ = self.removeCookie(temp1, domain, temp2);
                    }
                }
            }
        }
    }

    # Removes all expired cookies.
    public function removeExpiredCookies() {
        Cookie[] persistentCookies = self.persistentCookieHandler.getCookies();
        //TODO: get persistent cookies
        string? temp1 = ();
        string? temp2 = ();
        string? temp3 = ();
        lock {
            // If expired, removes those persistent cookies from the database.
            foreach var cookie in persistentCookies {
                if (isExpired(cookie)) {
                    temp1 = cookie.name;
                    temp2 = cookie.domain;
                    temp3 = cookie.path;
                    if (temp1 is string && temp2 is string && temp3 is string) {
                        _ = self.persistentCookieHandler.removeCookie(temp1, temp2, temp3);
                    }
                }
            }
        }
    }

    # Removes all the cookies.
    public function clear() {
        lock {
            // TODO:Remove all persistent cookies from the database.
            self.allSessionCookies = [];
            self.persistentCookieHandler.clearAllCookies();
        }
    }
};

const string HTTP = "http";
const string HTTPS = "https";
const string URL_TYPE_1 = "https://www.";
const string URL_TYPE_2 = "http://www.";
const string URL_TYPE_3 = "http://";
const string URL_TYPE_4 = "https://";

// Extracts domain name from the request URL.
function getDomain(string url) returns string {
    string domain = url;
    if (url.startsWith(URL_TYPE_1)) {
        domain = url.substring(URL_TYPE_1.length(), url.length());
    } else if (url.startsWith(URL_TYPE_2)) {
        domain = url.substring(URL_TYPE_2.length(), url.length());
    } else if (url.startsWith(URL_TYPE_3)) {
        domain = url.substring(URL_TYPE_3.length(), url.length());
    } else if (url.startsWith(URL_TYPE_4)) {
        domain = url.substring(URL_TYPE_4.length(), url.length());
    }
    return domain;
}

# Gets the identical cookie for a given cookie if one exists.
# Identical cookie is the cookie, which has the same name, domain and path as the given cookie.
#
# + cookieToCompare - Cookie to be compared
# + cookieStore - Cookie store of the client
# + return - Identical cookie if one exists, else `()`
function getIdenticalCookie(Cookie cookieToCompare, CookieStore cookieStore) returns Cookie? {
    // Searches for the session cookies.
    Cookie[] allCookies = cookieStore.getAllCookies();
    int k = 0 ;
    while (k < allCookies.length()) {
        if (cookieToCompare.name == allCookies[k].name && cookieToCompare.domain == allCookies[k].domain  && cookieToCompare.path ==  allCookies[k].path) {
            return allCookies[k];
        }
        k = k + 1;
    }
     // Searches for the persistent cookies.
     // TODO:get the same name, path and domain cookies from the database.
}

// Returns true if the cookie domain matches with the request domain according to [RFC-6265](https://tools.ietf.org/html/rfc6265#section-5.1.3).
function isDomainMatched(Cookie cookie, string domain, CookieConfig cookieConfig) returns boolean {
    if (cookie.domain == ()) {
        cookie.domain = domain;
        cookie.hostOnly = true;
        return true;
    }
    cookie.hostOnly = false;
    if (!cookieConfig.blockThirdPartyCookies) {
        return true;
    }
    var temp = cookie.domain;
    if (cookie.domain == domain || (temp is string && domain.endsWith("." + temp))) {
        return true;
    }
    return false;
}

// Returns true if the cookie path matches the request path according to [RFC-6265](https://tools.ietf.org/html/rfc6265#section-5.1.4).
function isPathMatched(Cookie cookie, string path, CookieConfig cookieConfig) returns boolean {
    if (cookie.path == ()) {
        cookie.path = path;
        return true;
    }
    if (!cookieConfig.blockThirdPartyCookies) {
        return true;
    }
    if (checkPath(path, cookie)) {
        return true;
    }
    return false;
}

function checkPath(string path, Cookie cookie) returns boolean {
    if (cookie.path == path) {
        return true;
    }
    var temp = cookie.path;
    if (temp is string && path.startsWith(temp) && temp.endsWith("/")) {
        return true;
    }
    if (temp is string && path.startsWith(temp) && path[temp.length()] == "/" ) {
        return true;
    }
    return false;
}

// Returns true if the cookie expires attribute value is valid according to [RFC-6265](https://tools.ietf.org/html/rfc6265#section-5.1.1).
function isExpiresAttributeValid(Cookie cookie) returns boolean {
    var temp = cookie.expires;
    if (temp is ()) {
         return true;
    } else {
        time:Time|error t1 = time:parse(temp.substring(0, temp.length() - 4), "E, dd MMM yyyy HH:mm:ss");
        if (t1 is time:Time) {
            int year = time:getYear(t1);
            if (year <= 69 && year >= 0) {
                time:Time tmAdd = time:addDuration(t1, 2000, 0, 0, 0, 0, 0, 0);
                string|error timeString = time:format(tmAdd, "E, dd MMM yyyy HH:mm:ss");
                if (timeString is string) {
                    cookie.expires = timeString + " GMT";
                    return true;
                }
                return false;
            }
            return true;
        }
        return false;
    }
}

// Adds a persistent cookie to the cookie store according to the rules in [RFC-6265](https://tools.ietf.org/html/rfc6265#section-5.3 , https://tools.ietf.org/html/rfc6265#section-4.1.2).
function addPersistentCookie(Cookie? identicalCookie, Cookie cookie, string url, CookieStore cookieStore) {
    if (identicalCookie is Cookie) {
        var temp1 = identicalCookie.name;
        var temp2 = identicalCookie.domain;
        var temp3 = identicalCookie.path;
        if (isExpired(cookie) && temp1 is string && temp2 is string && temp3 is string) {
            _ = cookieStore.removeCookie(temp1, temp2, temp3);
        } else {
            // Removes the old cookie and adds the new persistent cookie.
            if (((identicalCookie.httpOnly && url.startsWith(HTTP)) || identicalCookie.httpOnly == false) && temp1 is string && temp2 is string && temp3 is string) {
                _ = cookieStore.removeCookie(temp1, temp2, temp3);
                cookie.creationTime = identicalCookie.creationTime;
                cookie.lastAccessedTime = time:currentTime();
                // TODO:insert into the database.
                cookieStore.persistentCookieHandler.storeCookie(cookie);
            }
        }
    } else {
        // If cookie is not expired adds that cookie.
        if (!isExpired(cookie)) {
            cookie.creationTime = time:currentTime();
            cookie.lastAccessedTime = time:currentTime();
            // TODO:insert into the database.
            cookieStore.persistentCookieHandler.storeCookie(cookie);
        }
    }
}

// Returns true if the cookie is expired according to the rules in [RFC-6265](https://tools.ietf.org/html/rfc6265#section-4.1.2.2).
function isExpired(Cookie cookie) returns boolean {
    if (cookie.maxAge > 0) {
        time:Time exptime = time:addDuration(cookie.creationTime, 0, 0, 0, 0, 0, cookie.maxAge, 0);
        time:Time curTime = time:currentTime();
        if (exptime.time < curTime.time) {
            return true;
        }
        return false;
    }
    var temp = cookie.expires;
    if (temp is string) {
        time:Time|error cookieExpires = time:parse(temp.substring(0, temp.length() - 4), "E, dd MMM yyyy HH:mm:ss");
        time:Time curTime = time:currentTime();
        if ((cookieExpires is time:Time) && cookieExpires.time < curTime.time) {
            return true;
        }
        return false;
    }
    return false;
}

// Adds a session cookie to the cookie store according to the rules in [RFC-6265](https://tools.ietf.org/html/rfc6265#section-5.3 , https://tools.ietf.org/html/rfc6265#section-4.1.2).
function addSessionCookie(Cookie? identicalCookie, Cookie cookie, string url, CookieStore cookieStore) {
    if (identicalCookie is Cookie) {
        var temp1 = identicalCookie.name;
        var temp2 = identicalCookie.domain;
        var temp3 = identicalCookie.path;
        // Removes the old cookie and adds the new session cookie.
        if (((identicalCookie.httpOnly && url.startsWith(HTTP)) || identicalCookie.httpOnly == false) && temp1 is string && temp2 is string && temp3 is string) {
            _ = cookieStore.removeCookie(temp1, temp2, temp3);
            cookie.creationTime = identicalCookie.creationTime;
            cookie.lastAccessedTime = time:currentTime();
            cookieStore.allSessionCookies.push(cookie);
        }
    } else {
        // Adds the session cookie.
        cookie.creationTime = time:currentTime();
        cookie.lastAccessedTime = time:currentTime();
        cookieStore.allSessionCookies.push(cookie);
    }
}

// Sets a given domain as a blocked domain.
public function setBlockedDomain(string domain) returns @tainted error? {
    io:WritableByteChannel writableFileResult = check io:openWritableFile("/home/tharuja/Documents/cookie-store-data.txt", true);
    io:WritableCharacterChannel dc =  new(writableFileResult, "UTF-8");
    var writeCharResult1 = check dc.write(domain, 0);
    var writeCharResult2 = check dc.write("\n", 0);
    closeWc(dc);
}

function closeWc(io:WritableCharacterChannel ch) {
    var cr = ch.close();
    if (cr is error) {
        log:printError("Error occurred while closing the channel: ", err = cr);
    }
}

// Returns true if given domain is blocked; false otherwise.
public function isDomainBlocked(string domain) returns boolean {
    var blockedDomains = getBlockedDomains();
    if (blockedDomains is string[]) {
        foreach var item in blockedDomains {
            if (domain == item) {
                return true;
            }
        }
    }
    return false;
}

// Returns an array of all the blocked domains;
function getBlockedDomains() returns @tainted string[] | error {
    string[] blockedDomains = [];
    io:ReadableByteChannel readableFieldResult = check io:openReadableFile("/home/tharuja/Documents/cookie-store-data.txt");
    io:ReadableCharacterChannel sc = new(readableFieldResult, "UTF-8");
    string result = check sc.read(500);
    blockedDomains = stringutils:split(result, "\n");
    closeRc(sc);
    return blockedDomains;
}

function closeRc(io:ReadableCharacterChannel ch) {
    var cr = ch.close();
    if (cr is error) {
        log:printError("Error occurred while closing the channel: ", err = cr);
    }
}

// Sets a given domain as an allowed domain.
public function setAllowedDomain(string domain) returns @tainted error? {
    var blockedDomains = getBlockedDomains();
    if (blockedDomains is string[]) {
        // Removes domain from file.
         int k = 0;
         while (k < blockedDomains.length()) {
            if (domain == blockedDomains[k]) {
                int j = k;
                while (j < blockedDomains.length()-1) {
                    blockedDomains[j] = blockedDomains[j + 1];
                    j = j + 1;
                }
                _ = blockedDomains.pop();
            }
            k = k + 1;
        }
        // Removes file.
       error? removeResults = file:remove("/home/tharuja/Documents/cookie-store-data.txt");
       if (removeResults is error) {
           return removeResults;
       }
       // Rewrites all.
       foreach var item in blockedDomains {
           var result = setBlockedDomain(item);
           if (result is error) {
               return result;
           }
       }
    } else {
        return blockedDomains;
    }
}
