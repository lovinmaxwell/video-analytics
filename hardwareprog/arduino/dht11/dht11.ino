#include <DHT.h>;
DHT dht(A0,DHT11);
float humidity;
float temperature;
void setup()
{
  Serial.begin(9600);
  delay(500); // delay to let system boot
  Serial.println("DHT11 Humidity and temperature Sensor\n\n");
  delay(1000); //wait before accessing sensor
}
//end "setup()"
void loop()
{
 humidity = dht.readHumidity();
 temperature = dht.readTemperature();
 //start of program
  Serial.print("Current humidity = ");
  Serial.print(humidity);
  Serial.print("% ");
  Serial.print("temperature = ");
  Serial.print(temperature);
  Serial.println("C ");
delay(5000);
}
