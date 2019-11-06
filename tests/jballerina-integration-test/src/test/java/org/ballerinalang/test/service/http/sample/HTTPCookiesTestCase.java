package org.ballerinalang.test.service.http.sample;

import io.netty.handler.codec.http.HttpHeaderNames;
import org.ballerinalang.test.service.http.HttpBaseTest;
import org.ballerinalang.test.util.HttpClientRequest;
import org.ballerinalang.test.util.HttpResponse;
import org.ballerinalang.test.util.TestConstant;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;


@Test(groups = "http-test")
public class HTTPCookiesTestCase extends HttpBaseTest {

    @Test(description = "Test sending a cookie with the response when a cookie client sends a request for the first time")
    public void testCookieClientFirstRequest() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9253, "cookie/firstRequest"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        Assert.assertEquals(response.getHeaders().get("Set-Cookie").toString(),"SID003=178gd4dmnmsddd34; Domain=localhost:9253; Path=/cookie/addCookiesToResponse; HttpOnly");
    }

    @Test(description = "Test adding cookie header with relevant cookies to the second request")
    public void testAddCookieHeadertoSecondRequest() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9253, "cookie/addCookieHeadertoSecondRequest"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        Assert.assertEquals(response.getData(), "SID003=178gd4dmnmsddd34; SID002=239d4dmnmsddd34", "Message content mismatched");
    }

    @Test(description = "Test adding cookie header with new  cookies and existing cookies to the third request")
    public void testAddCookieHeadertoThirdRequest() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9253, "cookie/addCookieHeaderToThirdRequest"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        Assert.assertEquals(response.getData(), "SID003=178gd4dmnmsddd34; SID002=239d4dmnmsddd34", "Message content mismatched");
    }

    @Test(description = "Test removing a cookie and request again")
    public void testRemoveCookieAndRequest() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9253, "cookie/removeCookieAndRequest"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        Assert.assertEquals(response.getData(), "SID003=178gd4dmnmsddd34", "Message content mismatched");
    }

    @Test(description = "Test sending the same session cookie and replacing with new one")
    public void testSendIdenticalCookie() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9253, "cookie/sendIdenticalCookie"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        Assert.assertEquals(response.getData(), "SID002=239d4dmnmsddd34", "Message content mismatched");
    }

}



//        HttpEntity entity = response.getEntity();
//
//        // Read the contents of an entity and return it as a String.
//        String content = EntityUtils.toString(entity);


//    @Test(description = "Test getting the added cookies from the inbound response")
//    public void testGetCookiesFromResponse() throws IOException {
//        HttpResponse response = HttpClientRuquest.doGet(serverInstance.getServiceURLHttp(9251, "cookie/getCookies"));
//        Assert.assertNotNull(response);
//
//    }

//    public void testAddCookieToResponse() throws IOException {
//        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9251, "cookie/addCookiesToResponse"));
//        Assert.assertNotNull(response);
//        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
//        Assert.assertEquals(response.getHeaders().get("Set-Cookie").toString(),"SID002=239d4dmnmsddd34; Domain=localhost:9251; Path=/cookie/addCookiesToResponse; HttpOnly");
//    }


//    @Test(description = "Test removing  the added cookie from client's cookie store")
//    public void testRemoveCookiesFromRemoteStore() throws IOException {
//        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9253, "cookie/removeCookiesFromRemoteStore"));
//        Assert.assertNotNull(response);
//        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
//        Assert.assertEquals(response.getHeaders().get("Set-Cookie").toString(),"SID002=239d4dmnmsddd34; Domain=google.com; Path=/sample; Expires=Sat, 12 Mar 1994 08:12:22 GMT; HttpOnly; Secure");
//    }