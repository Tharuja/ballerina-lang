/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.net.grpc.callback;

import org.ballerinalang.jvm.values.ErrorValue;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.StreamObserver;
import org.ballerinalang.net.grpc.listener.ServerCallHandler;

import static org.ballerinalang.net.grpc.GrpcConstants.EMPTY_DATATYPE_NAME;

/**
 * Call back class registered for streaming gRPC service in B7a executor.
 *
 * @since 0.995.0
 */
public class UnaryCallableUnitCallBack extends AbstractCallableUnitCallBack {

    private StreamObserver requestSender;
    private boolean emptyResponse;
    
    public UnaryCallableUnitCallBack(StreamObserver requestSender, boolean isEmptyResponse) {
        this.requestSender = requestSender;
        this.emptyResponse = isEmptyResponse;
    }
    
    @Override
    public void notifySuccess() {
        // check whether connection is closed.
        if (requestSender instanceof ServerCallHandler.ServerCallStreamObserver) {
            ServerCallHandler.ServerCallStreamObserver serverCallStreamObserver = (ServerCallHandler
                    .ServerCallStreamObserver) requestSender;
            if (!serverCallStreamObserver.isReady()) {
                return;
            }
            if (serverCallStreamObserver.isCancelled()) {
                return;
            }
        }
        // notify success only if response message is empty. Service impl doesn't send empty message. Empty response
        // scenarios handles here.
        if (emptyResponse) {
            requestSender.onNext(new Message(EMPTY_DATATYPE_NAME, null));
        }
        // Notify complete if service impl doesn't call complete;
        requestSender.onCompleted();
        super.notifySuccess();
    }
    
    @Override
    public void notifyFailure(ErrorValue error) {
        handleFailure(requestSender, error);
        super.notifyFailure(error);
    }
}
