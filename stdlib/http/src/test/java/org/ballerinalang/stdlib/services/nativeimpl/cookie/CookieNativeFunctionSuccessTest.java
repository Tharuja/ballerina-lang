/*
 * Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */


package org.ballerinalang.stdlib.services.nativeimpl.cookie;

import io.netty.handler.codec.http.DefaultHttpHeaders;
import io.netty.handler.codec.http.HttpHeaderNames;
import io.netty.handler.codec.http.HttpHeaders;
import org.ballerinalang.jvm.util.exceptions.BallerinaException;
import org.ballerinalang.jvm.values.ArrayValue;
import org.ballerinalang.jvm.values.MapValueImpl;
import org.ballerinalang.jvm.values.ObjectValue;
import org.ballerinalang.jvm.values.XMLItem;
import org.ballerinalang.mime.util.MimeConstants;
import org.ballerinalang.mime.util.MimeUtil;
import org.ballerinalang.model.util.JsonParser;
import org.ballerinalang.model.util.StringUtils;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BRefType;
import org.ballerinalang.model.values.BString;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.model.values.BValueArray;
import org.ballerinalang.model.values.BXML;
import org.ballerinalang.net.http.HttpConstants;
import org.ballerinalang.net.http.HttpUtil;
import org.ballerinalang.stdlib.io.channels.base.Channel;
import org.ballerinalang.stdlib.utils.HTTPTestRequest;
import org.ballerinalang.stdlib.utils.MessageUtils;
import org.ballerinalang.stdlib.utils.ResponseReader;
import org.ballerinalang.stdlib.utils.Services;
import org.ballerinalang.stdlib.utils.TestEntityUtils;
import org.ballerinalang.test.util.BCompileUtil;
import org.ballerinalang.test.util.BRunUtil;
import org.ballerinalang.test.util.CompileResult;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import org.wso2.transport.http.netty.message.HttpCarbonMessage;
import org.wso2.transport.http.netty.message.HttpMessageDataStreamer;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.ballerinalang.mime.util.MimeConstants.APPLICATION_FORM;
import static org.ballerinalang.mime.util.MimeConstants.APPLICATION_JSON;
import static org.ballerinalang.mime.util.MimeConstants.APPLICATION_XML;
import static org.ballerinalang.mime.util.MimeConstants.CHARSET;
import static org.ballerinalang.mime.util.MimeConstants.ENTITY_BYTE_CHANNEL;
import static org.ballerinalang.mime.util.MimeConstants.ENTITY_HEADERS;
import static org.ballerinalang.mime.util.MimeConstants.IS_BODY_BYTE_CHANNEL_ALREADY_SET;
import static org.ballerinalang.mime.util.MimeConstants.OCTET_STREAM;
import static org.ballerinalang.mime.util.MimeConstants.REQUEST_ENTITY_FIELD;
import static org.ballerinalang.mime.util.MimeConstants.TEXT_PLAIN;
import static org.ballerinalang.mime.util.MimeUtil.isNotNullAndEmpty;
import static org.ballerinalang.stdlib.utils.TestEntityUtils.enrichEntityWithDefaultMsg;
import static org.ballerinalang.stdlib.utils.TestEntityUtils.enrichTestEntity;
import static org.ballerinalang.stdlib.utils.TestEntityUtils.enrichTestEntityHeaders;
//import static org.ballerinalang.stdlib.utils.ValueCreatorUtils.createEntityObject;
//import static org.ballerinalang.stdlib.utils.ValueCreatorUtils.createRequestObject;

/**
 * Test cases for ballerina/http cookie success native functions.
 */
public class CookieNativeFunctionSuccessTest {

    private CompileResult result;
    private static final int MOCK_ENDPOINT_PORT = 9090;

    @BeforeClass
    public void setup() {
        String resourceRoot = Paths.get("src", "test", "resources").toAbsolutePath().toString();
        Path sourceRoot = Paths.get(resourceRoot, "test-src", "services", "nativeimpl",
                "cookie");
        result = BCompileUtil.compile(sourceRoot.resolve("cookie-native-function.bal").toString());
    }

    @Test(description = "add cookie from the same domain and path to the cookie store")
    public void testAddCookieToCookieStore1() {

        BValue[] returnVals = BRunUtil.invoke(result, "testAddCookieToCookieStore1");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "add cookie from a subdomain to the cookie store")
    public void testAddCookieToCookieStore2() {

        BValue[] returnVals = BRunUtil.invoke(result, "testAddCookieToCookieStore2");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "add the host only cookie to the cookie store")
    public void testAddCookieToCookieStore3() {

        BValue[] returnVals = BRunUtil.invoke(result, "testAddCookieToCookieStore3");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "add cookie with unspecified path to the cookie store")
    public void testAddCookieToCookieStore4() {

        BValue[] returnVals = BRunUtil.invoke(result, "testAddCookieToCookieStore4");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "add cookie from a subpath to the cookie store")
    public void testAddCookieToCookieStore5() {

        BValue[] returnVals = BRunUtil.invoke(result, "testAddCookieToCookieStore5");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "add array of cookies to the cookie store")
    public void testAddCookiesToCookieStore() {

        BValue[] returnVals = BRunUtil.invoke(result, "testAddCookiesToCookieStore");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 2, "No cookie objects in the Return Values");
    }

    @Test(description = "get the relevant cookie for the same domain and path from cookie store")
    public void testGetCookiesFromCookieStore1() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookiesFromCookieStore1");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "get the relevant cookie for a sub domain from cookie store")
    public void testGetCookiesFromCookieStore2() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookiesFromCookieStore2");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "get a host only cookie for the relevant domain from cookie store")
    public void testGetCookiesFromCookieStore3() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookiesFromCookieStore3");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "get the relevant cookie for a sub path from cookie store")
    public void testGetCookiesFromCookieStore4() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookiesFromCookieStore4");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "get a cookie with unspecified path for the relevant path from cookie store")
    public void testGetCookiesFromCookieStore5() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookiesFromCookieStore5");
        Assert.assertFalse(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Invalid Return Values.");
        Assert.assertTrue(returnVals.length == 1, "No cookie objects in the Return Values");
    }

    @Test(description = "remove a specific cookie from cookie store")
    public void testRemoveCookieFromCookieStore() {
        BValue[] returnVals = BRunUtil.invoke(result, "testRemoveCookieFromCookieStore");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");
    }

    @Test(description = "remove all cookies from cookie store")
    public void testClearCookieStore() {
        BValue[] returnVals = BRunUtil.invoke(result, "testClearAllCookiesInCookieStore");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");
    }
}