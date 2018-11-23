// microphone.ino - print audio volume level to serial. Print "Sound" on loud sound.
// (c) BotBook.com - Karvinen, Karvinen, Valtokari


const int audioPin = A0;
const int sensitivity = 850;

void setup() {
  Serial.begin(115200);  
}

void loop() {
  int soundWave = analogRead(audioPin);  // <1>
  Serial.println(soundWave/204.6);
  delay(10);
}

