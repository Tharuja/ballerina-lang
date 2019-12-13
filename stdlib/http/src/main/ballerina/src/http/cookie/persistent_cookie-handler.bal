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

# The representation of a persistent cookie handler for managing persistent cookies.
public type PersistentCookieHandler abstract object {
    # Checks if the request can be authenticated with the relevant `InboundAuthHandler` implementation.
    #
    # + cookie - Cookie to be added
    # + return - Returns `true` if can be authenticated. Else, returns `false`
    public function storePersistentCookies(Cookie cookie) returns boolean;

    # Tries to authenticate the request with the relevant `InboundAuthHandler` implementation.
    #
   # + return - Array of persistent cookies stored in the cookie store
    public function getPersistentCookies() returns Cookie[];
};
