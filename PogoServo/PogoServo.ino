#include <Servo.h>
Servo serv; 

void setup(){ 
  serv.attach(9);
}
 
void loop() { 
  serv.write(90);
  hitRight();
  hitLeft();
} 

// Make arm hit to the right
void hitRight() {
  serv.write(0);               // Swing
  delay(420);
  serv.write(90);              // Pause
  delay(888);
  serv.write(180);             // Swing Back
  delay(415);
  serv.write(90);              // Pause
}

// Make arm hit to the left
void hitLeft() {
  serv.write(180);              // Swing
  delay(420);
  serv.write(90);               // Pause
  delay(888);
  serv.write(0);                // Swing Back
  delay(420);
  serv.write(90);               // Pause
}
