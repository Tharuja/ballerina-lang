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

import ballerina/time;
import ballerina/log;
import ballerina/lang.'int as ints;


#Represents a Cookie
# 
# + name - name of the cookie.
# + value - value of the cookie.
# + path - URI path to which the cookie belongs.
# + domain - host to which the cookie will be sent .
# + maxAge - maximum lifetime of the cookie, represented as number of seconds until the cookie expires.
# + expires - maximum lifetime of the cookie, represented as date and time at which the cookie expires.
# + httpOnly - cookie is sent only to http requests.
# + secure - cookie is sent only to secure channels.
# + t1 - before time.


    public type Cookie object {

        public string name ="";
        public string value="";
        public string domain="";
        public string path="";
        public int maxAge=0;
        public string expires="";
        public boolean httpOnly=false;
        public boolean secure=false;

        time:Time|error t1= time:currentTime();
         

        //Returns false if the cookie will be discarded at the end of the "session"; true otherwise.
        public function isPersistent() returns boolean {
              if(self.expires == "" && self.maxAge == 0) {
                  return false;
              }
              else {
                  return true;
              }
        }

        //Returns true if the attributes of the cookie are in the correct format; false otherwise.
        public function isValid() returns boolean{
               if(self.name == "" || self.value == ""){
                     return false;
                }
                if(self.domain != ""){
                     self.domain= self.domain.toLowerAscii();
                }
               if(self.domain.startsWith(".")){
                     self.domain=self.domain.substring(1,self.domain.length());
                }
                if(self.domain.endsWith(".")){
                    self.domain=self.domain.substring(0,self.domain.length()-1);
               }
               if(self.path != "" && !self.path.startsWith("/")){
                    return false;
               }

               return true;

        }

         //Get the Cookie object in its string representation to be used in response header ‘Set-Cookie’.
         public function toStringValue() returns string{

             string setCookieHeaderValue="";
             setCookieHeaderValue= appendNameValuePair(setCookieHeaderValue,self.name,self.value);

               if(self.domain!=""){
                       setCookieHeaderValue= appendNameValuePair(setCookieHeaderValue,"Domain",self.domain);
               }
                if(self.path!=""){
                       setCookieHeaderValue= appendNameValuePair(setCookieHeaderValue,"Path",self.path);
               }
                 if(self.expires!="" && self.convertTime()){
                       setCookieHeaderValue= appendNameValuePair(setCookieHeaderValue,"Expires",self.expires);
               }
                if(self.maxAge>0){
                       setCookieHeaderValue= appendNameIntValuePair(setCookieHeaderValue,"Max-Age",self.maxAge);
               }
               if(self.httpOnly==true){
                       setCookieHeaderValue= appendOnlyName(setCookieHeaderValue,"HttpOnly");
               }

              if(self.secure==true){
                       setCookieHeaderValue= appendOnlyName(setCookieHeaderValue,"Secure");
               }

              setCookieHeaderValue=setCookieHeaderValue.substring(0,setCookieHeaderValue.length()-2);
              return setCookieHeaderValue;
         }

         public function convertTime() returns boolean{
            self.t1= time:parse(self.expires,"yyyy-MM-dd HH:mm:ss");
            if (self.t1 is time:Time){
                 string|error myTimeString = time:format(<time:Time>self.t1, "E, dd MMM yyyy HH:mm:ss ");
            if (myTimeString is string){
                self.expires=myTimeString +"GMT";
                return true;
            }
                return false;
            }
            else{
                log:printWarn("Invalid input date");
                return false;
            }
         }

    };


       const string EQUALS = "=";
       const string SPACE  = " ";
       const string SEMICOLON = ";";


        public  function appendNameValuePair(string setCookieHeaderValue,string name,string value) returns string{

            string resultString;
            resultString=setCookieHeaderValue+name+EQUALS+value+SEMICOLON+SPACE;

            return resultString;
        }

        public  function appendOnlyName(string setCookieHeaderValue,string name) returns string{

            string resultString;
            resultString=setCookieHeaderValue+name+SEMICOLON+SPACE;

            return resultString;
        }
        public  function appendNameIntValuePair(string setCookieHeaderValue,string name,int value) returns string{

            string resultString;
            resultString=setCookieHeaderValue+name+EQUALS+value.toString()+SEMICOLON+SPACE;

            return resultString;
        }

        //Returns the cookie object from Set-Cookie header string value.
        public function toCookie(string cookieStringValue) returns Cookie

        {
            Cookie cookie=new;
            string cookieValue=cookieStringValue;
            string[] result=[];
            int i=0;

               while(cookieValue.length()!=0)
               {
                   int? index = cookieValue.indexOf(";");
                    if (index is int) {
                  result[i]=cookieValue.substring(0,index);
                cookieValue=cookieValue.substring(index+2,cookieValue.length());
                       i=i+1;
                        }
               else{
                    result[i]=cookieValue;
                   break;
               }

               }


          int? index = result[0].indexOf("=");
             if (index is int) {
                  cookie.name=result[0].substring(0,index);
                  cookie.value=result[0].substring(index+1,result[0].length());
             }

            foreach string item in result {

                string attributeName="";
                string attributeValue="";
                index = item.indexOf("=");
                if (index is int) {
                  attributeName=item.substring(0,index);
                  attributeValue=item.substring(index+1,item.length());

                 }

                  match attributeName {
                    "Domain" => {
                      cookie.domain=attributeValue;

                    }
                    "Path" => {
                      cookie.path=attributeValue;

                    }
                    "Max-Age" => {
                       int|error age = ints:fromString(attributeValue);
                      if (age is int) {

                      cookie.maxAge=age;
                      }
                   }

                      "Expires" => {
                      cookie.expires=attributeValue;


                    }
                      "Secure" => {
                      cookie.secure=true;


                    }
                      "HttpOnly" => {
                      cookie.httpOnly=true;


                    }

                }
            }

           return cookie;
        }






