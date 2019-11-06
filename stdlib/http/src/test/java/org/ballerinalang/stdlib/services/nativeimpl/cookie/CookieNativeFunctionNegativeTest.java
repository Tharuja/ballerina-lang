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
import io.netty.util.internal.StringUtil;
import org.ballerinalang.jvm.values.ObjectValue;
import org.ballerinalang.model.values.BError;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.net.http.HttpConstants;
import org.ballerinalang.stdlib.utils.TestEntityUtils;
import org.ballerinalang.test.util.BAssertUtil;
import org.ballerinalang.test.util.BCompileUtil;
import org.ballerinalang.test.util.BRunUtil;
import org.ballerinalang.test.util.CompileResult;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import static org.ballerinalang.mime.util.MimeConstants.APPLICATION_JSON;
import static org.ballerinalang.mime.util.MimeConstants.APPLICATION_XML;
import static org.ballerinalang.mime.util.MimeConstants.ENTITY_HEADERS;
import static org.ballerinalang.mime.util.MimeConstants.IS_BODY_BYTE_CHANNEL_ALREADY_SET;
import static org.ballerinalang.mime.util.MimeConstants.PROTOCOL_PACKAGE_MIME;
import static org.ballerinalang.mime.util.MimeConstants.RESPONSE_ENTITY_FIELD;
import static org.ballerinalang.mime.util.MimeConstants.TEXT_PLAIN;
//import static org.ballerinalang.stdlib.utils.ValueCreatorUtils.createEntityObject;
//import static org.ballerinalang.stdlib.utils.ValueCreatorUtils.createResponseObject;

/**
 * Test cases for ballerina/http inbound response negative native functions.
 */
public class CookieNativeFunctionNegativeTest {

    private CompileResult result, resultNegative;


    @BeforeClass
    public void setup() {
        String basePath = "test-src/services/nativeimpl/cookie/";
        result = BCompileUtil.compile(basePath + "cookie-native-function-negative.bal");

    }

    @Test(description = "add a cookie with unmatched domain to the cookie store")
    public void testAddCookieWithUnmatchedDomain() {
        BValue[] returnVals = BRunUtil.invoke(result, "testAddCookieWithUnmatchedDomain");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");;
    }

    @Test(description = "add a cookie with unmatched path to the cookie store")
    public void testAddCookieWithUnmatchedPath() {
        BValue[] returnVals = BRunUtil.invoke(result, "testAddCookieWithUnmatchedPath");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");;
    }

    @Test(description = "get a secure only cookie to unsecure request url")
    public void testGetSecureCookieFromCookieStore() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetSecureCookieFromCookieStore");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");;
    }

    @Test(description = "get a http only cookie to non-http request url")
    public void testGetHttpOnlyCookieFromCookieStore() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetHttpOnlyCookieFromCookieStore");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");;
    }

    @Test(description = "get a host only cookie for a subdomain from cookie store ")
    public void testGetCookieToUnmatchedDomain1() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookieToUnmatchedDomain1");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");;
    }

    @Test(description = "get a cookie to unmatched request domain")
    public void testGetCookieToUnmatchedDomain2() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookieToUnmatchedDomain2");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");;
    }

    @Test(description = "get a cookie to unmatched request path")
    public void testGetCookieToUnmatchedPath1() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookieToUnmatchedPath1");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");;
    }

    @Test(description = "get a cookie with unspecified path to unmatched request path")
    public void testGetCookieToUnmatchedPath2() {
        BValue[] returnVals = BRunUtil.invoke(result, "testGetCookieToUnmatchedPath2");
        Assert.assertTrue(returnVals == null || returnVals.length == 0 || returnVals[0] == null,
                "Cookie objects are in the Return Values");;
    }
}
