
function testToJsonString() returns map<string> {
    json aNil = ();
    json aString = "aString";
    json aNumber = 10;
    json aFloatNumber = 10.5;
    json anArray = ["hello", "world"];
    map<string> aStringMap = { name : "anObject", value : "10", sub : "Science"};
    map<()|int|float|boolean|string| map<json>> anotherMap = { name : "anObject", value : "10", sub : "Science",
        intVal: 2324, boolVal: true, floatVal: 45.4, nestedMap: {xx: "XXStr", n: 343, nilVal: ()}};
    json anObject = { name : "anObject", value : 10, sub : { subName : "subObject", subValue : 10 }};
    map<()|int|float|boolean|string| map<json>>[] aArr =
        [{ name : "anObject", value : "10", sub : "Science", intVal: 2324, boolVal: true, floatVal: 45.4, nestedMap:
        {xx: "XXStr", n: 343, nilVal: ()}}, { name : "anObject", value : "10", sub : "Science"}];
    map<string> result = {};

    result["aNil"] = aNil.toJsonString();
    result["aString"] = aString.toJsonString();
    result["aNumber"] = aNumber.toJsonString();
    result["aFloatNumber"] = aFloatNumber.toJsonString();
    result["anArray"] = anArray.toJsonString();
    result["anObject"] = anObject.toJsonString();
    result["aStringMap"] = aStringMap.toJsonString();
    result["anotherMap"] = anotherMap.toJsonString();
    result["aArr"] = aArr.toJsonString();
    return result;
}

function testFromJsonString() returns map<json|error> {
    string aNil = "()";
    string aNull = "null";
    string aString = "\"aString\"";
    string aNumber = "10";
    //string aFloatNumber = "10.5";
    string anArray = "[\"hello\", \"world\"]";
    string anObject = "{\"name\":\"anObject\", \"value\":10, \"sub\":{\"subName\":\"subObject\", \"subValue\":10}}";
    string anInvalid = "{\"name\":\"anObject\",";
    map<json|error> result = {};

    result["aNil"] = aNil.fromJsonString();
    result["aNull"] = aNull.fromJsonString();
    result["aString"] = aString.fromJsonString();
    result["aNumber"] = aNumber.fromJsonString();
    //result["aFloatNumber"] = aFloatNumber.fromJsonString();
    result["anArray"] = anArray.fromJsonString();
    result["anObject"] = anObject.fromJsonString();
    result["anInvalid"] = anInvalid.fromJsonString();
    return result;
}

function testToStringMethod() returns [string, string, string, string] {
    int a = 4;
    anydata b = a;
    any c = b;
    var d = c.toString();
    return [a.toString(), b.toString(), c.toString(), d];
}

/////////////////////////// Tests for `mergeJson()` ///////////////////////////
const MERGE_JSON_ERROR_REASON = "{ballerina}MergeJsonError";
const MESSAGE = "message";

function testNilAndNonNilJsonMerge() returns boolean {
    json j1 = ();
    json j2 = { one: "hello", two: 2 };
    json j3 = 5;

    json|error mj1 = j1.mergeJson(j2);
    json|error mj2 = j2.mergeJson(j1);

    json|error mj3 = j1.mergeJson(j3);
    json|error mj4 = j3.mergeJson(j1);

    return mj1 is json && mj1 === j2 && mj2 is json && mj2 === j2 && mj3 is json && mj3 == j3 &&
        mj4 is json && mj4 == j3;
}

function testNonNilNonMappingJsonMerge() returns boolean {
    json j1 = 34.5;
    json j2 = ["hello", "world"];

    json|error mj = j1.mergeJson(j2);
    return mj is error && mj.reason() == MERGE_JSON_ERROR_REASON &&
        mj.detail()[MESSAGE] == "Cannot merge JSON values of types 'float' and 'json[]'";
}

function testMappingJsonAndNonMappingJsonMerge1() returns boolean {
    json j1 = { one: "hello", two: "world", three: 1 };
    json j2 = "string value";

    json|error mj = j1.mergeJson(j2);
    return mj is error && mj.reason() == MERGE_JSON_ERROR_REASON &&
        mj.detail()[MESSAGE] == "Cannot merge JSON values of types 'map<json>' and 'string'";
}

function testMappingJsonAndNonMappingJsonMerge2() returns boolean {
    json j1 = { one: "hello", two: "world", three: 1 };
    json[] j2 = [1, 2];

    json|error mj = j1.mergeJson(j2);
    return mj is error && mj.reason() == MERGE_JSON_ERROR_REASON &&
        mj.detail()[MESSAGE] == "Cannot merge JSON values of types 'map<json>' and 'json[]'";
}

function testMappingJsonNoIntersectionMergeSuccess() returns boolean {
    json j1 = { one: "hello", two: "world", three: 1 };
    map<json> j2 = { x: 12.0, y: "test value" };

    json|error mje = j1.mergeJson(j2);

    if (!(mje is map<json>) || mje.length() != 5) {
        return false;
    }

    json mj = <json> mje;
    return mj.one == "hello" && mj.two == "world" && mj.three == 1 && mj.x == 12.0 && mj.y == "test value";
}

function testMappingJsonWithIntersectionMergeFailure1() returns boolean {
    json j1 = { one: "hello", two: "world", three: 1 };
    json j2 = { two: 1, y: "test value" };

    json j1Clone = j1.clone();
    json j2Clone = j2.clone();

    json|error mj = j1.mergeJson(j2);

    if (!(mj is error) || mj.reason() != MERGE_JSON_ERROR_REASON ||
            mj.detail()[MESSAGE] != "JSON Merge failed for key 'two'") {
        return false;
    }

    error err = <error> mj;
    error cause = <error> err.detail()?.cause;
    return cause.reason() == MERGE_JSON_ERROR_REASON &&
            cause.detail()[MESSAGE] == "Cannot merge JSON values of types 'string' and 'int'" &&
            j1 == j1Clone && j2 == j2Clone;
}

function testMappingJsonWithIntersectionMergeFailure2() returns boolean {
    json j1 = { one: { a: "one", b: 2 }, three: 1 };
    json j2 = { two: "test value", one: true };

    json j1Clone = j1.clone();
    json j2Clone = j2.clone();

    json|error mj = j1.mergeJson(j2);

    if (!(mj is error) || mj.reason() != MERGE_JSON_ERROR_REASON ||
            mj.detail()[MESSAGE] != "JSON Merge failed for key 'one'") {
        return false;
    }

    error err = <error> mj;
    error cause = <error> err.detail()?.cause;
    return cause.reason() == MERGE_JSON_ERROR_REASON &&
            cause.detail()[MESSAGE] == "Cannot merge JSON values of types 'map<json>' and 'boolean'" &&
            j1 == j1Clone && j2 == j2Clone;
}

function testMappingJsonWithIntersectionMergeSuccess() returns boolean {
    json j1 = { one: "hello", two: (), three: 1, four: { a: (), b: "test", c: "value" } };
    json j2 = { four: { a: "strings", b: () }, one: (), two: "world", five: 5  };

    json j2Clone = j2.clone();
    json|error mj = j1.mergeJson(j2);

    if (mj is error) {
        return false;
    } else {
        map<json> expMap = { a: "strings", b: "test", c: "value" };
        map<json> mj4 = <map<json>> mj.four;
        return mj === j1 && mj.one == "hello" && mj.two == "world" && mj.three == 1 &&
            mj4 == expMap && mj.five == 5 && j2 == j2Clone;
    }
}

function testMergeJsonSuccessForValuesWithNonIntersectingCyclicRefererences() returns boolean {
    map<json> j1 = { x: { a: 1 } };
    j1["z"] = j1;
    map<json> j2 = { x: { b: 2 } };
    j2["p"] = j2;
    var result = j1.mergeJson(j2);
    return j1.x == <json> { a: 1, b: 2 } && j1.z === j1 && j2.p === j2;
}

function testMergeJsonFailureForValuesWithIntersectingCyclicRefererences() returns boolean {
    map<json> j1 = { x: { a: 1 } };
    j1["z"] = j1;
    map<json> j2 = { x: { b: 2 } };
    j2["z"] = j2;

    var result = j1.mergeJson(j2);
    if (result is json || result.detail()?.message != "JSON Merge failed for key 'z'") {
        return false;
    } else {
        error? cause = result.detail()?.cause;
        if (cause is () || cause.detail()?.message != "Cannot merge JSON values with cyclic references") {
            return false;
        }
    }
    return j1.x == <json> { a: 1 } && j2.x == <json> { b: 2 } && j1.z == j1 && j2.z == j2;
}
