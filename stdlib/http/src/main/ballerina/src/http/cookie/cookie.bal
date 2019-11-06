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

import ballerina/lang.'int as ints;
import ballerina/stringutils;
import ballerina/time;

#Represents a Cookie
# 
# + name - name of the cookie.
# + value - value of the cookie.
# + path - URI path to which the cookie belongs.
# + domain - host to which the cookie will be sent .
# + maxAge - maximum lifetime of the cookie, represented as number of seconds until the cookie expires.
# + expires - maximum lifetime of the cookie, represented as date and time at which the cookie expires.
# + httpOnly - cookie is sent only to http requests.
# + secure - cookie is sent only to secure channels.
# + t1 - time used to foramt the expires time.
# + creationTime - creation time of the cookie.
# + lastAccessedTime - last accessed time of the cookie.
# + hostOnly - cookie is sent only to the current host.

public type Cookie object {

    public string name = "";
    public string value = "";
    public string domain = "";
    public string path = "";
    public int maxAge = 0;
    public string expires = "";
    public boolean httpOnly = false;
    public boolean secure = false;
    public time:Time creationTime = time:currentTime();
    public time:Time lastAccessedTime = time:currentTime();
    public boolean hostOnly = false;

    time:Time | error t1 = time:currentTime();

    //Returns false if the cookie will be discarded at the end of the "session"; true otherwise.
    public function isPersistent() returns boolean {
        if (self.expires == "" && self.maxAge == 0) {
            return false;
        } else {
            return true;
        }
    }

    //Returns true if the attributes of the cookie are in the correct format; false otherwise.
    public function isValid() returns boolean | error {
        error invalidCookieError;
        if (self.name == "" || self.value == "") {
            invalidCookieError = error("Empty name value pair");
            return invalidCookieError;
        }
        if (self.domain != "") {
            self.domain = self.domain.toLowerAscii();
        }
        if (self.domain.startsWith(".")) {
            self.domain = self.domain.substring(1, self.domain.length());
        }
        if (self.domain.endsWith(".")) {
            self.domain = self.domain.substring(0, self.domain.length() - 1);
        }
        if (self.path != "" && !self.path.startsWith("/")) {
            invalidCookieError = error("Path is not in correct format ");
            return invalidCookieError;
        }
        if (self.expires != "" && !self.toGmtFormat()) {
            invalidCookieError = error("Time is not in correct format");
            return invalidCookieError;
        }
        if (self.maxAge < 0) {
            invalidCookieError = error("Max Age is less than zero");
            return invalidCookieError;
        }
        return true;
    }

    //Gets the Cookie object in its string representation to be used in response header ‘Set-Cookie’.
    public function toStringValue() returns string {
        string setCookieHeaderValue = "";
        setCookieHeaderValue = appendNameValuePair(setCookieHeaderValue, self.name, self.value);
        if (self.domain != "") {
            setCookieHeaderValue = appendNameValuePair(setCookieHeaderValue, "Domain", self.domain);
        }
        if (self.path != "") {
            setCookieHeaderValue = appendNameValuePair(setCookieHeaderValue, "Path", self.path);
        }
        if (self.expires != "") {
            setCookieHeaderValue = appendNameValuePair(setCookieHeaderValue, "Expires", self.expires);
        }
        if (self.maxAge > 0) {
            setCookieHeaderValue = appendNameIntValuePair(setCookieHeaderValue, "Max-Age", self.maxAge);
        }
        if (self.httpOnly == true) {
            setCookieHeaderValue = appendOnlyName(setCookieHeaderValue, "HttpOnly");
        }
        if (self.secure == true) {
            setCookieHeaderValue = appendOnlyName(setCookieHeaderValue, "Secure");
        }
        setCookieHeaderValue = setCookieHeaderValue.substring(0, setCookieHeaderValue.length() - 2);
        return setCookieHeaderValue;
    }

    //Converts the given time into GMT format.
    function toGmtFormat() returns boolean {
        self.t1 = time:parse(self.expires, "yyyy-MM-dd HH:mm:ss");
        if (self.t1 is time:Time) {
            string | error myTimeString = time:format(<time:Time>self.t1, "E, dd MMM yyyy HH:mm:ss ");
            if (myTimeString is string) {
                self.expires = myTimeString + "GMT";
                return true;
            }
            return false;
        } else {
            return false;
        }
    }
};

const string EQUALS = "=";
const string SPACE = " ";
const string SEMICOLON = ";";

function appendNameValuePair(string setCookieHeaderValue, string name, string value) returns string {
    string resultString;
    resultString = setCookieHeaderValue + name + EQUALS + value + SEMICOLON + SPACE;
    return resultString;
}

function appendOnlyName(string setCookieHeaderValue, string name) returns string {
    string resultString;
    resultString = setCookieHeaderValue + name + SEMICOLON + SPACE;
    return resultString;
}
function appendNameIntValuePair(string setCookieHeaderValue, string name, int value) returns string {
    string resultString;
    resultString = setCookieHeaderValue + name + EQUALS + value.toString() + SEMICOLON + SPACE;
    return resultString;
}

//Returns the cookie object from Set-Cookie header string value.
public function parseSetCookieHeader(string cookieStringValue) returns Cookie {
    Cookie cookie = new;
    string cookieValue = cookieStringValue;
    string[] result = stringutils:split(cookieValue, "; ");
    string[] nameValuePair = stringutils:split(result[0], "=");
    cookie.name = nameValuePair[0];
    cookie.value = nameValuePair[1];
    foreach var item in result {
        nameValuePair = stringutils:split(item, "=");
        match nameValuePair[0] {
            "Domain" => {
                cookie.domain = nameValuePair[1];
            }
            "Path" => {
                cookie.path = nameValuePair[1];
            }
            "Max-Age" => {
                int | error age = ints:fromString(nameValuePair[1]);
                if (age is int) {
                    cookie.maxAge = age;
                }
            }
            "Expires" => {
                cookie.expires = nameValuePair[1];
            }
            "Secure" => {
                cookie.secure = true;
            }
            "HttpOnly" => {
                cookie.httpOnly = true;
            }
        }
    }
    return cookie;
}

//Sort cookies in order to make Cookie header for the request.
public function sortCookies(Cookie[] cookiesToAdd) {
    int i = 0;
    int j = 0;
    Cookie temp = new ();
    while (i < cookiesToAdd.length()) {
        j = i + 1;
        while (j < cookiesToAdd.length()) {
            if (cookiesToAdd[i].path.length() < cookiesToAdd[j].path.length()) {
                temp = cookiesToAdd[i];
                cookiesToAdd[i] = cookiesToAdd[j];
                cookiesToAdd[j] = temp;
            }
            if (cookiesToAdd[i].path.length() == cookiesToAdd[j].path.length()) {
                //sort according to time
                time:Time | error t1 = cookiesToAdd[i].creationTime;
                time:Time | error t2 = cookiesToAdd[j].creationTime;
                if (t1 is time:Time && t2 is time:Time) {
                    if (t1.time > t2.time) {
                        temp = cookiesToAdd[i];
                        cookiesToAdd[i] = cookiesToAdd[j];
                        cookiesToAdd[j] = temp;
                    }
                }
            }
            j = j + 1;
        }
        i = i + 1;
    }
}

//Returns an array of cookie objects from Cookie header string value.
public function parseCookieHeader(string cookieStringValue) returns Cookie[] {
    Cookie[] cookiesInRequest = [];
    string cookieValue = cookieStringValue;
    int i = 0;
    string[] nameValuePairs = stringutils:split(cookieValue, "; ");
    foreach var item in nameValuePairs {
        string[] nameValue = stringutils:split(item, "=");
        Cookie cookie = new;
        cookie.name = nameValue[0];
        cookie.value = nameValue[1];
        cookiesInRequest[i] = cookie;
        i = i + 1;
    }
    return cookiesInRequest;
}






