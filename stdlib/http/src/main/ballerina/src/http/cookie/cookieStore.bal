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

//import ballerina/io;
//import ballerina/stringutils;
import ballerina/time;

#Represents the cookie store
#
# + allSessionCookies - array to store all the cookies temporarily.
# + cookieCount - total number of persistent cookies stored in the cookie store.
# + cookiesPerDomain - total number of cookies per domain.
public type CookieStore object {

    Cookie[] allSessionCookies = [];
    int cookieCount = 0;
    int cookiesPerDomain = 0;

    #Add a cookie to the cookie store
    #
    # + cookie - Cookie to be added.
    # + cookieConfig - Configurations associated with cookies
    # + url - Target service url
    # + path - Resource path
    public function addCookie(Cookie cookie, CookieConfig cookieConfig, string url, string path) {
        string domain = getDomain(url);
        Cookie? identicalCookie = getIdenticalCookie(cookie, self.allSessionCookies);
            if(checkDomain(cookie, domain, cookieConfig) && checkPath(cookie, path, cookieConfig) && checkExpiresAttr(cookie) && ((url.startsWith("http") && cookie.httpOnly) || cookie.httpOnly == false)) {
                if(cookie.isPersistent()) {
                    if(cookieConfig.enablePersistent) {
                        if(identicalCookie is Cookie) {
                            if(isExpired(cookie)) {
                                //delete old cookie
                                boolean isRemoved = self.removeCookie(identicalCookie.name, identicalCookie.domain, identicalCookie.path);
                            } else {
                                //delete old and add new one.(replace similar cookies)
                                if((identicalCookie.httpOnly == true && url.startsWith("http")) || identicalCookie.httpOnly == false ) {
                                    cookie.creationTime = identicalCookie.creationTime;
                                    boolean isRemoved =  self.removeCookie(identicalCookie.name, identicalCookie.domain, identicalCookie.path);
                                    cookie.lastAccessedTime = time:currentTime();
                                    //TODO:write to file
                               }
                            }
                        } else {
                            //check expiry and add/not add
                            if(!isExpired(cookie)) {
                                cookie.creationTime = time:currentTime();
                                cookie.lastAccessedTime = time:currentTime();
                                //TODO:write to file
                            }
                        }
                    }
                } else {
                    //new cookie is a session cookie
                    if(identicalCookie is Cookie) {
                        //delete old and add new session cookie
                        if((identicalCookie.httpOnly == true && url.startsWith("http")) || identicalCookie.httpOnly == false ) {
                            cookie.creationTime = identicalCookie.creationTime;
                            boolean isRemoved =  self.removeCookie(identicalCookie.name, identicalCookie.domain, identicalCookie.path);
                            cookie.lastAccessedTime = time:currentTime();
                            self.allSessionCookies[self.allSessionCookies.length()] = cookie;
                       }
                    } else {
                        //add session cookie
                        self.allSessionCookies[self.allSessionCookies.length()] = cookie;
                        cookie.creationTime = time:currentTime();
                        cookie.lastAccessedTime = time:currentTime();
                    }

                }
            }
    }
     #Add array of cookies.
     #
     # + cookiesInResponse - Cookies to be added.
     # + cookieConfig - Configurations associated with cookies
     # + url - Target service url
     # + path - Resource path
     public function addCookies(Cookie[] cookiesInResponse, CookieConfig cookieConfig, string url, string path) {
         foreach var cookie in cookiesInResponse {
             self.addCookie(cookie, cookieConfig, url, path);
         }
     }

     #Get the relevant cookies according to given url and path
     #
     # + url - URL of the request URI.
     # + path - path of the request URI.
     # + return - Array of matched cookies stored in the cookie store.
     public function getCookies(string url, string path) returns Cookie[] {
         Cookie[] cookiesToReturn = [];
         string domain = getDomain(url);
         //gets session cookies
         foreach var cookie in self.allSessionCookies {
            if((url.startsWith("https") && cookie.secure) || cookie.secure == false) {
             if((url.startsWith("http") && cookie.httpOnly) || cookie.httpOnly == false) {
                 if(cookie.hostOnly == true) {
                     if(cookie.domain == domain && matchPath(path, cookie)) {
                         cookiesToReturn[cookiesToReturn.length()]=cookie;
                     }
                 } else {
                      if((domain.endsWith("." + cookie.domain) || cookie.domain == domain ) && matchPath(path, cookie)) {
                         cookiesToReturn[cookiesToReturn.length()]=cookie;
                      }

                 }
             }
            }

         }
         //TODO:Get persistent cookies by reading files
         return cookiesToReturn;
     }

     #Get all the session and persistent cookies
     #
     # + return - All the session and persistent cookies
     public function getAllCookies() returns Cookie[] {
         //TODO:Get persistent cookies
         return self.allSessionCookies;
     }
     #Remove a specific cookie.
     #
     # + name - name of the cookie to be removed.
     # + domain - domain of the cookie to be removed.
     # + path - path of the cookie to be removed.
     # + return - return true if the relevant cookie is removed, false otherwise
     public function removeCookie(string name, string domain, string path) returns boolean {
         //remove if it is a session cookie
         int k = 0;
         while(k < self.allSessionCookies.length()) {
             if(name == self.allSessionCookies[k].name && domain == self.allSessionCookies[k].domain  && path ==  self.allSessionCookies[k].path) {
                 int j = k;
                 while(j< self.allSessionCookies.length()-1) {
                     self.allSessionCookies[j] = self.allSessionCookies[j+1];
                     j = j + 1;
                 }
                 Cookie lastCookie = self.allSessionCookies.pop();
                 return true;
             }
             k = k + 1;
         }
         //TODO:Remove file if it is a persistent cookie
         return false;
     }

     #Remove all expired cookies
     public function removeExpiredCookies() {
         //TODO:If expired remove file
     }

      #Remove all the session and persistent cookies.
      public function clear() {
          //TODO:Remove all files
          self.allSessionCookies = [];
      }
};

//Returns true , if cookie path matches with request path according to rfc-6265
function matchPath(string path, Cookie cookie) returns boolean {
    if(cookie.path == path) {
        return true;
    }
    if(path.startsWith(cookie.path) && cookie.path.endsWith("/")) {
        return true;
    }
    if(path.startsWith(cookie.path) && path[cookie.path.length()] == "/" ) {
        return true;
    }
    return false;
}
//Extracts domain name from the request url.
function getDomain(string url) returns string {
    string domain = url;
    if(url.startsWith("https://www.")) {
        domain = url.substring(12, url.length());
    }
    else if(url.startsWith("http://www.")) {
        domain = url.substring(11, url.length());
    }
    else if(url.startsWith("http://")) {
        domain = url.substring(7, url.length());
    }
    else if(url.startsWith("https://")) {
        domain = url.substring(8, url.length());
    }
    return domain;
}

function checkDomain(Cookie cookie, string domain, CookieConfig cookieConfig) returns boolean {
    if(cookie.domain == "") {
        cookie.domain = domain;
        cookie.hostOnly = true;
        return true;
    } else {
        if(cookieConfig.blockThirdPartyCookies) {
            cookie.hostOnly = false;
            if(cookie.domain == domain || domain.endsWith("." + cookie.domain)) {
                return true;
            } else {
                return false;
            }
        } else {
            cookie.hostOnly = false;
            return true;
        }
    }
}

function checkPath(Cookie cookie, string path, CookieConfig cookieConfig) returns boolean {
    if(cookie.path == "") {
        cookie.path = path;
        return true;
    } else {
        if(cookieConfig.blockThirdPartyCookies) {
            if(matchPath(path, cookie)) {
                return true;
            } else {
                return false;
            }
        } else {
            return true;
        }
    }
}

function checkExpiresAttr(Cookie cookie) returns boolean {
    if(cookie.expires != "") {
        time:Time|error t1 = time:parse(cookie.expires.substring(0,cookie.expires.length()-4), "E, dd MMM yyyy HH:mm:ss");
        if(t1 is time:Time){
            int year = time:getYear(t1);
            if(year <= 69 && year >= 0) {
                time:Time tmAdd = time:addDuration(t1, 2000, 0, 0, 0, 0, 0, 0);
                string|error timeString = time:format(tmAdd, "E, dd MMM yyyy HH:mm:ss");
                if (timeString is string) {
                    cookie.expires = timeString + " GMT";
                    return true;
                } else {
                    return false;
                }
            }
            return true;
        } else {
            return false;
        }
    }
    return true;
}

function getIdenticalCookie(Cookie cookieToCompare, Cookie[] allSessionCookies) returns Cookie? {
    //search session cookies
    int k = 0 ;
    while(k < allSessionCookies.length()) {
        if(cookieToCompare.name == allSessionCookies[k].name && cookieToCompare.domain == allSessionCookies[k].domain  && cookieToCompare.path ==  allSessionCookies[k].path) {
            return allSessionCookies[k];
        }
        k = k + 1;
    }
    //search persistent cookies
    //TODO:get the same name,path,domain cookies from the files
}

function isExpired(Cookie cookie) returns boolean {
    if(cookie.expires != "") {
        time:Time|error cookieExpires = time:parse(cookie.expires.substring(0,cookie.expires.length()-4), "E, dd MMM yyyy HH:mm:ss");
        time:Time curTime = time:currentTime();
        if (cookieExpires is time:Time) {
            if(cookieExpires.time < curTime.time){
                return true;
            }
        } else {
            return false;
        }
    }
    return false;
}


