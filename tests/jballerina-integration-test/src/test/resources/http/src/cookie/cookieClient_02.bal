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

import ballerina/http;
import ballerina/io;

public function main() {
    http:Client cookieclientEndpoint = new ("http://localhost:9253", { cookieConfig: {enabled: true}});
    http:Request req = new;
    //first request -send cookies in the response.
    var response = cookieclientEndpoint->get("/cookie/cookieBackend", req);
    //remove a session cookie
    http:CookieStore myCookieStore = new;
    myCookieStore = cookieclientEndpoint.getCookieStore();
    boolean isRemoved = myCookieStore.removeCookie("SID001", "localhost:9253", "/cookie" );
    //send a request again  after removed  one session  cookie
    response = cookieclientEndpoint->get("/cookie/cookieBackend", req);
    if (response is http:Response) {
        var payload = response.getTextPayload();
        if (payload is string) {
            io:print(payload);
        }
    }
}