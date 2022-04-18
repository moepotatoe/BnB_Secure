#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>

const char* ssid     = "402_Payment_Required";
const char* password = "I_cho0se_you";
const char* host = "127.0.0.1:8080"; 

//#define DEBUG   //If you comment this line, the DPRINT & DPRINTLN lines are defined as blank.
#ifdef DEBUG    //Macros are usually in all capital letters.
  #define DPRINT(...)    Serial.print(__VA_ARGS__)     //DPRINT is a macro, debug print
  #define DPRINTLN(...)  Serial.println(__VA_ARGS__)   //DPRINTLN is a macro, debug print with new line
#else
  #define DPRINT(...)     //now defines a blank line
  #define DPRINTLN(...)   //now defines a blank line
#endif

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  delay(10);
 
  // Start connecting to a WiFi network
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  
  // Waiting to connect
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  // When connected to the WIFI
  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

const byte numChars = 20;
char receivedChars[numChars]; // an array to store the received data
boolean newData = false;

void loop() {
  // put your main code here, to run repeatedly:
  receiveWithEndMarker();
  processRFIDTag();
}

void  receiveWithEndMarker() {
  static byte index =0;
  char endMarker = '\n';
  char rc;

  while (Serial.available() > 0 && newData == false) {
    rc = Serial.read();
    if (rc != endMarker) {
      receivedChars[index] = rc;
      index++;
      if (index >= numChars) {
        index = numChars - 1;
      }
     }else{
        receivedChars[index] = '\0'; // terminate the string
        index = 0;
        newData = true;
     }
  }   
}

void processRFIDTag() {
    if (newData == true) {
        DPRINT("This just in ... ");
        DPRINTLN(receivedChars);
        newData = false;
        isUserAuthorized(receivedChars);
    }
}

void isUserAuthorized(String RFIDTag){
    // wait for WiFi connection
  if ((WiFi.status() == WL_CONNECTED)) {
    WiFiClient client;
    HTTPClient http;
    // NOTE:  CHANGE THIS TO THE IP ADDRESS WHERE YOUR APPLICATION IS RUNNING
    String url = "http://127.0.0.1:8080/student/isauthorized?rf_id_code=";
    String encodedRFIDTAG = urlEncode(RFIDTag);
    url += encodedRFIDTAG;
    DPRINT("url :: ");
    DPRINTLN(url);

    http.setTimeout(20000);
    if (http.begin(client, url)) {  // HTTP

      // start connection and send HTTP header
      int httpCode = http.GET();
      DPRINT("httpCode :: ");
      DPRINTLN(httpCode);

      // httpCode will be negative on error
      if (httpCode > 0) {
        // HTTP header has been send and Server response header has been handled

        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
          String payload = http.getString();
          DPRINTLN(payload);
          sendDataBackToArduino(payload);

        }
      } else {
        Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
      }

      http.end();
    } else {
      Serial.printf("[HTTP} Unable to connect\n");
    }
  }
}

String urlEncode(String str) {
    String encodedString="";
    char c;
    char code0;
    char code1;
    char code2;
    for (int i =0; i < str.length(); i++){
      c = str.charAt(i);
      if (c == ' '){
        encodedString += '+';
      } else if (isalnum(c)){
        encodedString += c;
      } else {
        code1=(c & 0xf)+'0';
        if ((c & 0xf) >9){
            code1=(c & 0xf) - 10 + 'A';
        }
        c=(c>>4)&0xf;
        code0=c+'0';
        if (c > 9){
            code0=c - 10 + 'A';
        }
        code2='\0';
        encodedString+='%';
        encodedString+=code0;
        encodedString+=code1;
        //encodedString+=code2;
      }
      yield();
    }
    return encodedString;   
}

void sendDataBackToArduino(String payload){
  const size_t capacity = JSON_OBJECT_SIZE(1) + 30;
  DynamicJsonDocument doc(capacity);
    // Parse JSON object
  DeserializationError error = deserializeJson(doc, payload);
  if (error) {
    Serial.print(F("deserializeJson() failed: "));
    Serial.println(error.c_str());
    return;
  }
  serializeJson(doc, Serial);
}
