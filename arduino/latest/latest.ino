#define ENABLE 5
#define DIRA 3
#define DIRB 4

 
void setup() {
  //---set pin direction
  pinMode(ENABLE,OUTPUT);
  pinMode(DIRA,OUTPUT);
  pinMode(DIRB,OUTPUT);
  Serial.begin(9600);
  digitalWrite(ENABLE,HIGH);
  analogWrite(ENABLE,255); //enable on  
}

void loop() {
  if (Serial.available() > 0) {
    int num = Serial.parseInt();
    
    if (num == 1) {
      digitalWrite(DIRA,LOW); //one way
      digitalWrite(DIRB,HIGH);    
    }
    
    if (num == 2) {
      digitalWrite(DIRA,HIGH); //one way
      digitalWrite(DIRB,LOW);
    }
  }  
}


