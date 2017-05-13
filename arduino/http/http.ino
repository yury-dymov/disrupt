/*
 *  HTTP over TLS (HTTPS) example sketch
 *
 *  This example demonstrates how to use
 *  WiFiClientSecure class to access HTTPS API.
 *  We fetch and display the status of
 *  esp8266/Arduino project continuous integration
 *  build.
 *
 *  Created by Ivan Grokhotkov, 2015.
 *  This example is in public domain.
 */

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>

const char* ssid = "DisruptNYC";
const char* password = "";

const char* host = "thingspace.io";
const int httpPort = 80;
String url = "/get/latest/dweet/for/parkbikeclub";

bool locked = false;

void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.print("connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  // Use WiFiClientSecure class to create TLS connection
  Serial.print("connecting to ");
  Serial.println(host);
}

void loop() {
  WiFiClient client;

  if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;
  }
    
  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" +
               "User-Agent: BuildFailureDetectorESP8266\r\n" +
               "Connection: close\r\n\r\n");

  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      Serial.println("headers received");
      break;
    }
  }
  String line = client.readStringUntil('\n');
  
  StaticJsonBuffer<512> jsonBuffer;

  JsonObject& root = jsonBuffer.parseObject(line);

  if (root["with"] != NULL && sizeof(root["with"]) > 0) {
    int cnt = sizeof(root["with"]) / sizeof(root["with"][0]);

    if (root["with"][cnt - 1]["content"] && root["with"][cnt - 1]["content"]["locked"]) {
      const char* payload = root["with"][0]["content"]["locked"];

      bool haveToLock = false;

      if (!strcmp(payload, "true")) {
        haveToLock = true;
      }

      if (haveToLock != locked) {
        locked = haveToLock;
        Serial.print("toggline lock\n");
        delay(6000);
      }
    }
  }

  client.stop();
    
  delay(500);  
}
