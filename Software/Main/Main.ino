#include <WiFi.h>
#include <Adafruit_MQTT.h>
#include <Adafruit_MQTT_Client.h>
#include <OpenWeatherMap.h>

//WiFi connection settings
const char* WIFI_NAME = "WIFI_SSID";
const char* WIFI_PASSWORD = "WIFI_PASSWORD";
WiFiClient client;

//Adafruit mqtt connection setings
#define AIO_SERVER  "io.adafruit.com"
#define AIO_SERVERPORT  1883
#define AIO_USERNAME  "AIO_USERNAME"
#define AIO_KEY "AIO_KEY"
Adafruit_MQTT_Client mqtt(&client, AIO_SERVER, AIO_SERVERPORT, AIO_USERNAME, AIO_KEY);
Adafruit_MQTT_Publish temp = Adafruit_MQTT_Publish(&mqtt, "AIO_USERNAME/feeds/temp");
Adafruit_MQTT_Publish hum = Adafruit_MQTT_Publish(&mqtt, "AIO_USERNAME/feeds/hum");
Adafruit_MQTT_Publish mess = Adafruit_MQTT_Publish(&mqtt, "AIO_USERNAME/feeds/messages");

//OpenWeather settings
OpenWeatherMap weather;
const char* CITY = "Kyiv";
const char* COUNTRY = "UA";
const char* API_KEY = "OPENWEATHERMAP_API_KEY";
OWM_Forecast forecast;

//Pinout for physical connections
const byte SOIL_SUPPLY_PIN = 17;
const byte SOIL_DATA_PIN = 35;
const byte PUMP_PIN = 16;

//Soil sensor's calibratiing readings
const int WET_VALUE = 700;
const int DRY_VALUE = 4095;

//Data variables
int humData = 0;
const byte UPPER_THRESHOLD = 70;
const byte LOWER_THRESHOLD = 30;
const byte SAFETY_MARGIN = 10; //Safety margin value for max error calculation
double averageTemp = 0;
const unsigned long long hours = 3600000000ULL; //One hour in microseconds
const unsigned long DUTY_LENGTH = 60000; //Length of duty cycle in miliseconds
const unsigned long PUMP_MAX_WORKING_TIME = 5000; //Maximum pump working time
const unsigned long DUTY_CYCLE_LENGTH = 120000; //Length of the duty cycle

//Soil measuring function
void readSoilMoisture(){
  digitalWrite(SOIL_SUPPLY_PIN, HIGH);
  delay(1000);
  humData = analogRead(SOIL_DATA_PIN);
  digitalWrite(SOIL_SUPPLY_PIN, LOW);
  humData = map(humData, DRY_VALUE, WET_VALUE, 0, 100);
  humData = constrain(humData, 0, 100);
  hum.publish((uint32_t)humData);
  return;
}

//PD controller function
void discretePDControl(int& humData){
  //initializing of datatypes for variables
  double Kp = 0.214;
  double Td = 0.472;
  double MaxRawOutput = 0;
  double rawPDoutput = 0;
  double mappedPDoutput = 0;
  unsigned long  pumpWorkingTime = 0;
  unsigned long waitingTime = 0;
  int CurrentError = 0;
  int PrevError = 0;
  int maxError = 0;
  unsigned long time = 0;
  //Error calculations
  CurrentError = UPPER_THRESHOLD - humData;
  PrevError = CurrentError;
  maxError = UPPER_THRESHOLD - LOWER_THRESHOLD+SAFETY_MARGIN;
  MaxRawOutput = Kp * maxError; 
  //Duty cycle
  int c = 1;
  for(;CurrentError > 0;){
    //Mapping controller output, calculating pump work and waiting time 
    rawPDoutput = Kp * (CurrentError + Td * (CurrentError-PrevError));
    mappedPDoutput =  (rawPDoutput/MaxRawOutput);
    mappedPDoutput = constrain(mappedPDoutput, 0.2 ,1);
    mess.publish("PD output:");
    mess.publish(mappedPDoutput*5);
    mess.publish("seconds of pump working time");
    pumpWorkingTime = PUMP_MAX_WORKING_TIME * mappedPDoutput;
    time = millis();
    //turning ON pump for a calculated time
    digitalWrite(PUMP_PIN, HIGH);
    while((millis() - time) < pumpWorkingTime){
      
    }
    digitalWrite(PUMP_PIN, LOW);
    waitingTime = DUTY_CYCLE_LENGTH - pumpWorkingTime;
    delay(waitingTime);
    //Taking measurments of soil after watering
    PrevError = CurrentError;
    readSoilMoisture();
    //Calculating new error
    CurrentError = UPPER_THRESHOLD - humData;
    mess.publish("Cycle №");
    mess.publish((uint32_t)c);
    c++;
  };
  return;
}

//Average temp for 24hours using Open Weather Map forecast
void getAverageTemp(){
  mess.publish("Getting temperature forecast");
  weather.getForecastByCity(CITY, COUNTRY, &forecast, 8);
  double summ = 0;
  int i = 0;
  for (;i < forecast.cnt; i++){
    summ += forecast.items[i].main.temp;
  }
  if(i == 0){
    mess.publish("weather function error");
  } 
  else{
    averageTemp = summ/i;
    temp.publish(averageTemp);
  }
}

//Soil humidity prediction based on temp data. Func calculates hours of deep sleep and puts board in it.
void prediction(double CurrentH){
  getAverageTemp();
  if (averageTemp == 0){
    mess.publish("Skipping prediction");
  }
  mess.publish("Predicting soil evaporation");
  int c = 0;
  double Ke = 0.0123;
  while (CurrentH > (LOWER_THRESHOLD)){
    CurrentH = CurrentH -averageTemp * Ke; //Soil humidity formula
    c++;
  }
  //If calculated time is less then 24h, then call PD function. Esle exit function
  if(c<24){
    discretePDControl(humData);
    mess.publish("Sleeping for 24h");
    delay(1000);
    esp_sleep_enable_timer_wakeup(24ULL*hours);
    esp_deep_sleep_start();
  }
  else{
   return;
  }
}

//WiFi connection check fucnction. If board can't connect to WiFi for 30seconds - restart the ESP
void checkWiFi(){
  if(WiFi.status() == WL_CONNECTED) return;
  WiFi.disconnect(true, true);
  WiFi.begin(WIFI_NAME, WIFI_PASSWORD);
  int retry = 0;
  while (WiFi.status() != WL_CONNECTED && retry < 30){
    delay(1000);
    retry++;
  }
  if(WiFi.status() != WL_CONNECTED) {
    ESP.restart();
  }
}

//Adafruit connection function. If not connected, reconect attempt every 3seconds for 90seconds.
void conectMQTT(){
  int8_t server_respond;
  if(mqtt.connected()) return;
  int retry = 0;
  while((server_respond = mqtt.connect()) != 0 && retry < 30){
    mqtt.disconnect();
    delay(3000);
  }
  if(server_respond != 0){
    ESP.restart();
  }
}

//Initialization, MQTT connection, control execution and deep-sleep entry
void setup() {
  Serial.begin(9600);
  //Pin modes initialization and making sure they are off
  pinMode(SOIL_SUPPLY_PIN, OUTPUT);
  pinMode(PUMP_PIN, OUTPUT);
  digitalWrite(SOIL_SUPPLY_PIN, LOW);
  digitalWrite(PUMP_PIN, LOW);
  //Caling WiFi and mqtt connection functions 
  checkWiFi();
  conectMQTT();
  //Initializing weather library
  weather.begin(API_KEY);
  weather.setUnits(OWM_UNITS_METRIC);
  weather.setLanguage("en");

  //logic execution and deep-sleep
  delay(100); //startup delay
  readSoilMoisture();
  if (humData > (LOWER_THRESHOLD)){
    prediction(humData);
    mess.publish("Sleeping for 24h");
    delay(1000);
    esp_sleep_enable_timer_wakeup(24ULL*hours);
    esp_deep_sleep_start();
  }
  else{
    discretePDControl(humData);
    mess.publish("Sleeping for 24h");
    delay(1000);
    esp_sleep_enable_timer_wakeup(24ULL*hours);
    esp_deep_sleep_start();
  }
}


void loop() {

}
