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

# Represents the details of an error.
#
# + message - The error message.
# + cause - Cause of the error.
type Detail record {
    string message;
    error cause?;
};

public const FILE_PATH_ERROR = "{ballerina/filepath}Error";

public type Error error<FILE_PATH_ERROR, Detail>;

# Prepare the `error` as an `Error`.
#
# + message - The error message.
# + err - The `error` instance.
# + return - Prepared `Error` instance.
public function prepareError(string message, error? err = ()) returns Error {
    Error filepathError;
    if (err is error) {
	    filepathError = error(FILE_PATH_ERROR, message = message, cause = err);
    } else {
        filepathError = error(FILE_PATH_ERROR, message = message);
    }
    return filepathError;
}
