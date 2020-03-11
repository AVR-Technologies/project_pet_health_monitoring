#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

String apiWritekey = "55603HKHM7DOJ8KB"; //replace with your THINGSPEAK WRITEAPI key here
const char* ssid = "AVR"; // your wifi SSID name
const char* password = "//avrtech;";// wifi pasword
 
const char* server = "api.thingspeak.com";
float resolution=3.3/1023;//3.3 is the supply volt  & 1023 is max analog read value
WiFiClient client;
 float temp;
void setup() {
  Serial.begin(115200);
  WiFi.disconnect();
  delay(10);
  WiFi.begin(ssid, password);
 
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
 
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("NodeMcu connected to wifi...");
  Serial.println(ssid);
  Serial.println();
}
 
void loop() {
  temp = (analogRead(A0) * resolution) * 100;

if (WiFi.status() == WL_CONNECTED) { //Check WiFi connection status
HTTPClient http;  //Declare an object of class HTTPClient
String url="http://192.168.0.17/pet_health_monitoring/log_temp.php?collarId=2&temperature="+(String)temp;
http.begin(url);  //Specify request destination
int httpCode = http.GET();                                                                  //Send the request
 
if (httpCode > 0) { //Check the returning code
 
String payload = http.getString();   //Get the request response payload
Serial.println(payload);                     //Print the response payload
 
}
 
http.end();   //Close connection
delay(2000);
}
ThingSpeak_SEND();
delay(10000);
 
}

void ThingSpeak_SEND()
{
   if (client.connect(server,80))
  {  
    String tsData = apiWritekey;
           tsData +="&field2=";
           tsData += String(temp);
           tsData += "\r\n\r\n";
 
     client.print("POST /update HTTP/1.1\n");
     client.print("Host: api.thingspeak.com\n");
     client.print("Connection: close\n");
     client.print("X-THINGSPEAKAPIKEY: "+apiWritekey+"\n");
     client.print("Content-Type: application/x-www-form-urlencoded\n");
     client.print("Content-Length: ");
     client.print(tsData.length());
     client.print("\n\n");  // the 2 carriage returns indicate closing of Header fields & starting of data
     client.print(tsData);
     
     Serial.print("Temperature: ");
     Serial.print(temp);
     Serial.println("uploaded to Thingspeak server....");
     delay(2000);
  }
  client.stop();
 
  Serial.println("Waiting to upload next reading...");
  Serial.println();
  // thingspeak needs minimum 15 sec delay between updates
  //delay(10000);
}
