//LED pins
int r = 5;
int g = 6;
int y = 7;
void setup()
{
  Serial.begin(9600);
  pinMode(r, OUTPUT);digitalWrite(r,LOW);
   pinMode(g, OUTPUT);digitalWrite(g,LOW);
    pinMode(y, OUTPUT);digitalWrite(y,LOW);
}
void traffic()
{
  digitalWrite(g,HIGH);
  Serial.println("Green LED:ON,GO");
  //delay of 5 seconds
  delay(5000);
  digitalWrite(g,LOW);
  digitalWrite(y,HIGH);
  Serial.println("Green LED:OFF;Yellow LED:ON, WAIT");
   delay(5000);
   digitalWrite(y,LOW);
  digitalWrite(r,HIGH);
  Serial.println("Yellow LED:OFF;Red LED:ON, STOP");
   delay(5000);
   digitalWrite(r, LOW);
   Serial.println("All OFF");
}
void loop()
{
  traffic();
  delay(10000);
}

