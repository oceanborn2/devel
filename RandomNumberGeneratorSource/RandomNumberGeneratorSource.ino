/*
  RandomNumber generator source
  created 2018
  by Pascal Munerot
*/

int pinCount = 1;          // the number of pins (i.e. the length of the array)

//byte[] source = new byte[16] { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };

void setup() {
  Serial.begin(115200);
}

void pulsePin(int pin, int wdelay = 30) {
  digitalWrite(pin, HIGH);
  delay(wdelay);
  digitalWrite(pin, LOW);
}

void loop() {
  int v0 = analogRead(A0);
  Serial.print(v0);
  int v1 = analogRead(A1);
  Serial.print(v1);
  int v3 = analogRead(A3);
  Serial.print(v3);
  int v4 = analogRead(A4);
  Serial.print(v4);

  //float voltage = analogRead(A0) * (5.0 / 1023.0);
  //Serial.println(voltage);
}

