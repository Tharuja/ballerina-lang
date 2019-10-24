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

    @Test(description = "Test adding a cookie to response")
    public void testAddCookieToResponse() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9251, "cookie/addCookies"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        Assert.assertEquals(response.getHeaders().get("Set-Cookie").toString(),"SID002=239d4dmnmsddd34; Domain=google.com; Path=/sample; Expires=Mon, 26 Jun 2017 05:46:22 GMT; Max-Age=3600; HttpOnly; Secure");


    }

    @Test(description = "Test removing  the added cookie from client's cookie store")
    public void testRemoveCookiesFromRemoteStore() throws IOException {
        HttpResponse response = HttpClientRequest.doGet(serverInstance.getServiceURLHttp(9251, "cookie/removeCookiesFromRemoteStore"));
        Assert.assertNotNull(response);
        Assert.assertEquals(response.getResponseCode(), 200, "Response code mismatched");
        Assert.assertEquals(response.getHeaders().get("Set-Cookie").toString(),"SID002=239d4dmnmsddd34; Domain=google.com; Path=/sample; Expires=Sat, 12 Mar 1994 08:12:22 GMT; Max-Age=3600; HttpOnly; Secure");


    }
//    @Test(description = "Test getting the added cookies from the inbound response")
//    public void testGetCookiesFromResponse() throws IOException {
//        HttpResponse response = HttpClientRuquest.doGet(serverInstance.getServiceURLHttp(9251, "cookie/getCookies"));
//        Assert.assertNotNull(response);
//
//    }
}
