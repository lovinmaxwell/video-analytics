void setup() {
  // set the pin mode
  pinMode(13, OUTPUT);

}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(13,HIGH); //turn on the led
  delay(1000);
  digitalWrite(13,LOW); //turn off the led
  delay(1000);
}
