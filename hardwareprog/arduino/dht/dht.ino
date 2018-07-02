#include<DHT.h>;
DHT dht(3,DHT11); //initialize dht sensor
float humidity;
float temperature;
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
Serial.println("Humidity:");
Serial.println(humidity);
Serial.println("Temperature:");
Serial.println(temperature);
Serial.println("Celsius");
delay(2000); //delay of 2 seconds
}

