#include<DHT.h>;
DHT dht(8,DHT22); //initialize dht sensor
float humidity;
float temperature;
value
void setup()
{
  Serial.begin(9600);
  dht.begin();
}
void loop()
{
  //read data from the sensor and store it to variables humidity and temperature
 humidity = dht.readHumidity();
 temperature = dht.readTemperature();
//print temperature and humidity valuse to serial monitor
Serial.print("Humidity:");
Serial.print(humidity);
Serial.print("%,Temperature:");
Serial.print(temperature);
Serial.print("Celsius");
delay(2000); //delay of 2 seconds
}

