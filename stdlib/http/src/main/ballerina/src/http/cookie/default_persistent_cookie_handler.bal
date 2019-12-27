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

import ballerina/io;
import ballerina/log;
import ballerina/file;
import ballerina/time;

type myCookie record {
    string name;
    string value;
    string domain;
    string path;
    string expires;
    int maxAge;
    boolean httpOnly;
    boolean secure;
    string creationTime;
    string lastAccessedTime;
    boolean hostOnly;
};

string fileName = "./cookies/persistent-cookies-store.csv";
string? cookieNameToRemove = ();
string? cookieDomainToRemove = ();
string? cookiePathToRemove = ();

public type DefaultPersistentCookieHandler  object {
    *PersistentCookieHandler;

    # Adds a persistent cookie to the cookie store.
    #
    # + cookie - Cookie to be added
    public function storeCookie(Cookie cookie) {
        table<myCookie> cookiesTable = table{};
        if (file:exists(fileName)) {
            cookiesTable = getFileDataIntoTable();
        }
        cookiesTable = addNewCookieToTable(cookiesTable, cookie);
        var result = writeToFile(cookiesTable);
        if (result is error) {
            log:printError("Error occurred while writing data to file: ", err = result);
        }
    }

    # Gets all persistent cookies.
    #
    # + return - Array of persistent cookies stored in the cookie store
    public function getCookies() returns Cookie[] {
        Cookie[] cookies = [];
        if (file:exists(fileName)) {
            var tblResult = readFile(fileName);
            if (tblResult is table<myCookie>) {
                foreach var rec in tblResult {
                    Cookie cookie = new(rec.name, rec.value);
                    cookie.domain = rec.domain;
                    cookie.path = rec.path;
                    cookie.expires = rec.expires;
                    cookie.maxAge = rec.maxAge;
                    cookie.httpOnly = rec.httpOnly;
                    cookie.secure = rec.secure;
                    time:Time | error t1 = time:parse(rec.creationTime, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                    if (t1 is time:Time) {
                        cookie.creationTime = t1;
                    }
                    time:Time | error t2 = time:parse(rec.lastAccessedTime, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                    if (t2 is time:Time) {
                        cookie.lastAccessedTime = t2;
                    }
                    cookie.hostOnly = rec.hostOnly;
                    cookies.push(cookie);
                }
            } else {
                log:printError("An error occurred while reading file: ", err = tblResult);
            }
        }
       return cookies;
   }

    # Removes a specific persistent cookie.
    #
    # + name - Name of the persistent cookie to be removed
    # + domain - Domain of the persistent cookie to be removed
    # + path - Path of the persistent cookie to be removed
    # + return - Return true if the relevant persistent cookie is removed, false otherwise
    public function removeCookie(string name, string domain, string path) returns boolean {
        cookieNameToRemove = name;
        cookieDomainToRemove = domain;
        cookiePathToRemove = path;
        if (file:exists(fileName)) {
            table<myCookie> cookiesTable = getFileDataIntoTable();
            int | error count = cookiesTable.remove(removeCriteria);
            if (count is error || count <= 0) {
                log:printError("No such cookie to remove");
                return false;
            }
            error? removeResults = file:remove(fileName);
            if (removeResults is error) {
                log:printError("Error occurred while removing the existing file");
                return false;
            }
            var result = writeToFile(cookiesTable);
            if (result is error) {
                log:printError("Error occurred while writing updated table to file");
                return false;
            }
            return true;
        }
        log:printError("No persistent cookie store file to remove cookie");
        return false;
    }

    # Removes all persistent cookies.
    public function clearAllCookies() {
        error? removeResults = file:remove(fileName);
        if (removeResults is error) {
            log:printError("Error occurred while removing the persistent cookie store file: ", err = removeResults);
        }
    }
};

// Reads file and gets earlier data into a table.
function getFileDataIntoTable() returns @tainted table<myCookie> {
    table<myCookie> cookiesTable = table{};
    var tblResult = readFile(fileName);
    if (tblResult is table<myCookie>) {
        cookiesTable = tblResult;
    } else {
        log:printError("An error occurred while reading file: ", err = tblResult);
    }
    return cookiesTable;
}

function readFile(string fileName) returns @tainted error | table<myCookie> {
    io:ReadableCSVChannel rCsvChannel2 = check io:openReadableCsvFile(fileName);
    var tblResult = rCsvChannel2.getTable(myCookie);
    closeReadableCSVChannel(rCsvChannel2);
    return  tblResult;
}

function closeReadableCSVChannel(io:ReadableCSVChannel csvChannel) {
    var result = csvChannel.close();
    if (result is error) {
        log:printError("Error occurred while closing the channel: ", err = result);
    }
}

// Updates the table with new cookie.
function addNewCookieToTable(table<myCookie> cookiesTable, Cookie cookieToAdd) returns table<myCookie> {
    table<myCookie> tableToReturn = cookiesTable;
    var name = cookieToAdd.name;
    var value = cookieToAdd.value;
    var domain = cookieToAdd.domain;
    var path = cookieToAdd.path;
    var expires = cookieToAdd.expires;
    var creationTime = time:format(cookieToAdd.creationTime, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    var lastAccessedTime = time:format(cookieToAdd.lastAccessedTime, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    if (name is string && value is string && domain is string && path is string && expires is string && creationTime is string && lastAccessedTime is string) {
        myCookie c1 = { name: name, value: value, domain: domain, path: path, expires: expires, maxAge: cookieToAdd.maxAge, httpOnly: cookieToAdd.httpOnly, secure: cookieToAdd.secure, creationTime: creationTime, lastAccessedTime: lastAccessedTime, hostOnly: cookieToAdd.hostOnly };
        var result = tableToReturn.add(c1);
        if (result is error) {
            log:printError("Error occurred while adding data to table: ", err = result);
        }
    }
    return tableToReturn;
}

// Writes the updated table to file.
function writeToFile(table<myCookie> cookiesTable) returns @tainted error? {
    io:WritableCSVChannel wCsvChannel2 = check io:openWritableCsvFile(fileName);
    foreach var entry in cookiesTable {
        string[] rec = [entry.name, entry.value, entry.domain, entry.path, entry.expires, entry.maxAge.toString(), entry.httpOnly.toString(), entry.secure.toString(), entry.creationTime, entry.lastAccessedTime, entry.hostOnly.toString()];
        writeDataToCSVChannel(wCsvChannel2, rec);
    }
    closeWritableCSVChannel(wCsvChannel2);
}

function writeDataToCSVChannel(io:WritableCSVChannel csvChannel, string[]... data) {
    foreach var rec in data {
        var returnedVal = csvChannel.write(rec);
        if (returnedVal is error) {
            log:printError("Error occurred while writing to target file: ", err = returnedVal);
        }
    }
}

function closeWritableCSVChannel(io:WritableCSVChannel csvChannel) {
    var result = csvChannel.close();
    if (result is error) {
        log:printError("Error occurred while closing the channel: ", err = result);
    }
}

function removeCriteria(myCookie rec) returns boolean {
    if (rec.name == cookieNameToRemove && rec.domain == cookieDomainToRemove && rec.path == cookiePathToRemove) {
        return true;
    }
    return false;
}
