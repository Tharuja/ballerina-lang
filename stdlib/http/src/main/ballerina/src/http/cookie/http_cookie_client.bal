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

//import ballerina/config;
//import ballerina/io;
//import ballerina/log;
//import ballerina/mime;
//import ballerina/time;

# Provides cookie functionality across HTTP client actions.
#
# + url - Target service url
# + config - HTTP ClientEndpointConfig to be used for HTTP client invocation
# + cookieConfig - Configurations associated with cookies
# + httpClient - HTTP client for outbound HTTP requests
# + cookieStore - Store to keep cookies of the client
public type CookieClient object {

    public string url;
    public ClientConfiguration config;
    public CookieConfig cookieConfig;
    public HttpClient httpClient;
    public CookieStore cookieStore;

    # Create a cookie client with the given configurations.
    #
    # + url - Target service url
    # + config - HTTP ClientEndpointConfig to be used for HTTP client invocation
    # + cookieConfig - Configurations associated with cookies
    # + httpClient - HTTP client for outbound HTTP requests
    # + cookieStore - Store to keep cookies of the client
     public function __init(string url, ClientConfiguration config, CookieConfig cookieConfig, HttpClient httpClient, CookieStore cookieStore) {
        self.url = url;
        self.config = config;
        self.cookieConfig = cookieConfig;
        self.httpClient = httpClient;
        self.cookieStore = cookieStore;
    }

    # If the received response for the `get()` action is redirect eligible, redirect will be performed automatically
    # by this `get()` function.
    #
    # + path - Resource path
    # + message - An optional HTTP outbound request message or any payload of type `string`, `xml`, `json`,
    #             `byte[]`, `io:ByteChannel` or `mime:Entity[]`
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function get(string path, public RequestMessage message = ()) returns @tainted Response|ClientError {
        Request request = <Request>message;
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse = self.httpClient->get(path, message = request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # If the received response for the `post()` action is redirect eligible, redirect will be performed automatically
    # by this `post()` function.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ByteChannel` or `mime:Entity[]`
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function post(string path, RequestMessage message) returns Response|ClientError {
        Request request = <Request>message;
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse = self.httpClient->post(path, request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # If the received response for the `head()` action is redirect eligible, redirect will be performed automatically
    # by this `head()` function.
    #
    # + path - Resource path
    # + message - An optional HTTP outbound request message or or any payload of type `string`, `xml`, `json`,
    #             `byte[]`, `io:ByteChannel` or `mime:Entity[]`
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function head(string path, public RequestMessage message = ()) returns @tainted Response|ClientError {
        Request request = <Request>message;
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse = self.httpClient->head(path, message = request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # If the received response for the `put()` action is redirect eligible, redirect will be performed automatically
    # by this `put()` function.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ByteChannel` or `mime:Entity[]`
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function put(string path, RequestMessage message) returns Response|ClientError {
        Request request = <Request>message;
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse = self.httpClient->put(path, request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # The `forward()` function is used to invoke an HTTP call with inbound request's HTTP verb.
    #
    # + path - Resource path
    # + request - An HTTP inbound request message
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function forward(string path, Request request) returns Response|ClientError{
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse = self.httpClient->forward(path, request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # The `execute()` sends an HTTP request to a service with the specified HTTP verb. Redirect will be performed
    # only for HTTP methods.
    #
    # + httpVerb - HTTP verb value
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ByteChannel` or `mime:Entity[]`
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function execute(string httpVerb, string path, RequestMessage message) returns Response|ClientError {
        Request request = <Request>message;
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse = self.httpClient->execute(httpVerb, path, request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # If the received response for the `patch()` action is redirect eligible, redirect will be performed automatically
    # by this `patch()` function.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ByteChannel` or `mime:Entity[]`
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function patch(string path, RequestMessage message) returns Response|ClientError  {
        Request request = <Request>message;
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse =  self.httpClient->patch(path, request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # If the received response for the `delete()` action is redirect eligible, redirect will be performed automatically
    # by this `delete()` function.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ByteChannel` or `mime:Entity[]`
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function delete(string path, public RequestMessage message = ()) returns Response|ClientError  {
        Request request = <Request>message;
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse =  self.httpClient->delete(path, request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # If the received response for the `options()` action is redirect eligible, redirect will be performed automatically
    # by this `options()` function.
    #
    # + path - Resource path
    # + message - An optional HTTP outbound request message or any payload of type `string`, `xml`, `json`,
    #             `byte[]`, `io:ByteChannel` or `mime:Entity[]`
    # + return - The HTTP `Response` message, or an error if the invocation fails
    public function options(string path, public RequestMessage message = ()) returns Response|ClientError {
        Request request = <Request>message;
        AddStoredCookiesToRequest(self.url, path, self.cookieStore, request);
        var inboundResponse =  self.httpClient->options(path, message = request);
        return AddCookiesInResponseToStore(inboundResponse, self.cookieStore, self.cookieConfig, self.url, path);
    }

    # Submits an HTTP request to a service with the specified HTTP verb.
    # The `submit()` function does not give out a `Response` as the result,
    # rather it returns an `HttpFuture` which can be used to do further interactions with the endpoint .
    #
    # + httpVerb - The HTTP verb value
    # + path - The resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ByteChannel` or `mime:Entity[]`
    # + return - An `HttpFuture` that represents an asynchronous service invocation, or an error if the submission fails
    public function submit(string httpVerb, string path, RequestMessage message) returns HttpFuture|ClientError {
        Request request = <Request>message;
        return self.httpClient->submit(httpVerb, path, request);
    }

    # Retrieves the `Response` for a previously submitted request.
    #
    # + httpFuture - The `HttpFuture` relates to a previous asynchronous invocation
    # + return - An HTTP response message, or an error if the invocation fails
    public function getResponse(HttpFuture httpFuture) returns Response|ClientError {
        return self.httpClient->getResponse(httpFuture);
    }

    # Checks whether a `PushPromise` exists for a previously submitted request.
    #
    # + httpFuture - The `HttpFuture` relates to a previous asynchronous invocation
    # + return - A `boolean` that represents whether a `PushPromise` exists
    public function hasPromise(HttpFuture httpFuture) returns boolean {
        return self.httpClient->hasPromise(httpFuture);
    }

    # Retrieves the next available `PushPromise` for a previously submitted request.
    #
    # + httpFuture - The `HttpFuture` relates to a previous asynchronous invocation
    # + return - An HTTP Push Promise message, or an error if the invocation fails
    public function getNextPromise(HttpFuture httpFuture) returns PushPromise|ClientError{
        return self.httpClient->getNextPromise(httpFuture);
    }

    # Retrieves the promised server push `Response` message.
    #
    # + promise - The related `PushPromise`
    # + return - A promised HTTP `Response` message, or an error if the invocation fails
    public function getPromisedResponse(PushPromise promise) returns Response|ClientError {
        return self.httpClient->getPromisedResponse(promise);
    }

    # Rejects a `PushPromise`.
    # When a `PushPromise` is rejected, there is no chance of fetching a promised response using the rejected promise.
    #
    # + promise - The Push Promise to be rejected
    public function rejectPromise(PushPromise promise) {
        self.httpClient->rejectPromise(promise);
    }


};

function AddStoredCookiesToRequest(string url, string path, CookieStore cookieStore, Request request) {
     Cookie[] cookiesToSend = cookieStore.getCookies(url, path);
            if(cookiesToSend.length() != 0) {
                //has requested before and has cookies
                request.addCookies(cookiesToSend);
            }
}
function AddCookiesInResponseToStore(Response|ClientError inboundResponse, @tainted CookieStore cookieStore, CookieConfig cookieConfig, string url, string path) returns Response|ClientError {
        if (inboundResponse is Response) {
            Cookie[] cookiesInResponse = inboundResponse.getCookies();
            cookieStore.addCookies(cookiesInResponse, cookieConfig, url, path );
        }
        return inboundResponse;
}