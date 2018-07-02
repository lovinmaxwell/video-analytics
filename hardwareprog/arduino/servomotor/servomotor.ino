#include<Servo.h>
//including the servo library
int servoPin = 13;
Servo ServoDemo;//creating a servo object
void setup()
{
//the servo pin must be attached to the servo before it can be used
  ServoDemo.attach(servoPin);
}
void loop()
{
  //servo moves to zero degrees
  ServoDemo.write(0);
  delay(1000);
  //servo moves 90
  ServoDemo.write(90);
  delay(1000);
  //servo moves 180
  ServoDemo.write(180);
  delay(1000);
}

