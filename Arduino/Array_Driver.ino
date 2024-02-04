#include <Adafruit_INA219.h>
#include <Wire.h>

#define ELECT_YELLOW_POS_ENB 22
#define ELECT_YELLOW_POS_POL 23
#define ELECT_YELLOW_NEG_ENB 24
#define ELECT_YELLOW_NEG_POL 25

#define ELECT_GREEN_POS_ENB 27
#define ELECT_GREEN_POS_POL 26
#define ELECT_GREEN_NEG_ENB 28
#define ELECT_GREEN_NEG_POL 29

#define ELECT_BLUE_POS_ENB 31
#define ELECT_BLUE_POS_POL 30
#define ELECT_BLUE_NEG_ENB 32
#define ELECT_BLUE_NEG_POL 33

#define ELECT_PURPLE_POS_ENB 35
#define ELECT_PURPLE_POS_POL 34
#define ELECT_PURPLE_NEG_ENB 38
#define ELECT_PURPLE_NEG_POL 39

#define ELECT_GREY_POS_ENB 41
#define ELECT_GREY_POS_POL 40
#define ELECT_GREY_NEG_ENB 42
#define ELECT_GREY_NEG_POL 43

#define ELECT_WHITE_POS_ENB 45
#define ELECT_WHITE_POS_POL 44
#define ELECT_WHITE_NEG_ENB 46
#define ELECT_WHITE_NEG_POL 47

Adafruit_INA219 ina219Black(0x40);  //0x40
Adafruit_INA219 ina219Brown(0x41);  //0x41
Adafruit_INA219 ina219Red(0x44);     //0x44

String inputString = "";         // a String to hold incoming data
boolean stringComplete = false;  // whether the string is complete

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  
  if (! ina219Black.begin()) {
    Serial.println("Failed to find INA219 black chip");
    while (1) { delay(100); digitalWrite(LED_BUILTIN,!digitalRead(LED_BUILTIN)); }
  }
  if (! ina219Brown.begin()) {
    Serial.println("Failed to find INA219 brown chip");
    while (1) { delay(100); digitalWrite(LED_BUILTIN,!digitalRead(LED_BUILTIN)); }
  }
  if (! ina219Red.begin()) {
    Serial.println("Failed to find INA219 red chip");
    while (1) { delay(100); digitalWrite(LED_BUILTIN,!digitalRead(LED_BUILTIN)); }
  }

  pinMode(ELECT_YELLOW_NEG_ENB, OUTPUT);
  pinMode(ELECT_YELLOW_NEG_POL, OUTPUT);
  pinMode(ELECT_YELLOW_POS_ENB, OUTPUT);
  pinMode(ELECT_YELLOW_POS_POL, OUTPUT);
  
  pinMode(ELECT_GREEN_NEG_ENB, OUTPUT);
  pinMode(ELECT_GREEN_NEG_POL, OUTPUT);
  pinMode(ELECT_GREEN_POS_ENB, OUTPUT);
  pinMode(ELECT_GREEN_POS_POL, OUTPUT);
  
  pinMode(ELECT_BLUE_NEG_ENB, OUTPUT);
  pinMode(ELECT_BLUE_NEG_POL, OUTPUT);
  pinMode(ELECT_BLUE_POS_ENB, OUTPUT);
  pinMode(ELECT_BLUE_POS_POL, OUTPUT);
  
  pinMode(ELECT_PURPLE_NEG_ENB, OUTPUT);
  pinMode(ELECT_PURPLE_NEG_POL, OUTPUT);
  pinMode(ELECT_PURPLE_POS_ENB, OUTPUT);
  pinMode(ELECT_PURPLE_POS_POL, OUTPUT);
  
  pinMode(ELECT_GREY_NEG_ENB, OUTPUT);
  pinMode(ELECT_GREY_NEG_POL, OUTPUT);
  pinMode(ELECT_GREY_POS_ENB, OUTPUT);
  pinMode(ELECT_GREY_POS_POL, OUTPUT);
  
  pinMode(ELECT_WHITE_NEG_ENB, OUTPUT);
  pinMode(ELECT_WHITE_NEG_POL, OUTPUT);
  pinMode(ELECT_WHITE_POS_ENB, OUTPUT);
  pinMode(ELECT_WHITE_POS_POL, OUTPUT);

  RestStim();
  digitalWrite(LED_BUILTIN,true);

}

void loop() {
  // put your main code here, to run repeatedly:
  if (stringComplete) {
    Serial.println(getCurrents());
    //digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
    DriveElectrod(inputString);
    // clear the string:
    inputString = "";
    stringComplete = false;
  }

}

void DriveElectrod(String inputs){
  int pongMap[][4] = { {ELECT_PURPLE_NEG_ENB, ELECT_PURPLE_NEG_POL, ELECT_PURPLE_POS_ENB, ELECT_PURPLE_POS_POL},
                  {ELECT_GREEN_NEG_ENB, ELECT_GREEN_NEG_POL, ELECT_GREEN_POS_ENB, ELECT_GREEN_POS_POL},
                  {ELECT_WHITE_NEG_ENB, ELECT_WHITE_NEG_POL, ELECT_WHITE_POS_ENB, ELECT_WHITE_POS_POL},
                  {ELECT_YELLOW_NEG_ENB, ELECT_YELLOW_NEG_POL, ELECT_YELLOW_POS_ENB, ELECT_YELLOW_POS_POL},
                  {ELECT_GREY_NEG_ENB, ELECT_GREY_NEG_POL, ELECT_GREY_POS_ENB, ELECT_GREY_POS_POL},
                  {ELECT_BLUE_NEG_ENB, ELECT_BLUE_NEG_POL, ELECT_BLUE_POS_ENB, ELECT_BLUE_POS_POL}};
  int lastFind = 0;
  for (int i = 0; i<6; i++){
    int pos = inputs.indexOf(',', lastFind);
    int out = (inputs.substring(lastFind, pos)).toInt();
    lastFind = pos+1;
    if(out == 0){ //no output
      digitalWrite(pongMap[i][0], true);//NEG_ENB
      digitalWrite(pongMap[i][1], true);//NEG_POL
      digitalWrite(pongMap[i][2], true);//POS_ENB
      digitalWrite(pongMap[i][3], true);//POS_POL
    }
    else if (out == 1){ //positive output
      digitalWrite(pongMap[i][0], false);//NEG_ENB
      digitalWrite(pongMap[i][1], true);//NEG_POL
      digitalWrite(pongMap[i][2], false);//POS_ENB
      digitalWrite(pongMap[i][3], false);//POS_POL
    }
    else if (out == -1){ //negative output
      digitalWrite(pongMap[i][0], false);//NEG_ENB
      digitalWrite(pongMap[i][1], false);//NEG_POL
      digitalWrite(pongMap[i][2], false);//POS_ENB
      digitalWrite(pongMap[i][3], true);//POS_POL
    }
  }
}

void RestStim(){
  bool temp = true;
  digitalWrite(ELECT_YELLOW_NEG_ENB, temp);
  digitalWrite(ELECT_YELLOW_NEG_POL, temp);
  digitalWrite(ELECT_YELLOW_POS_ENB, temp);
  digitalWrite(ELECT_YELLOW_POS_POL, temp);
  
  digitalWrite(ELECT_GREEN_NEG_ENB, temp);
  digitalWrite(ELECT_GREEN_NEG_POL, temp);
  digitalWrite(ELECT_GREEN_POS_ENB, temp);
  digitalWrite(ELECT_GREEN_POS_POL, temp);
  
  digitalWrite(ELECT_BLUE_NEG_ENB, temp);
  digitalWrite(ELECT_BLUE_NEG_POL, temp);
  digitalWrite(ELECT_BLUE_POS_ENB, temp);
  digitalWrite(ELECT_BLUE_POS_POL, temp);
  
  digitalWrite(ELECT_PURPLE_NEG_ENB, temp);
  digitalWrite(ELECT_PURPLE_NEG_POL, temp);
  digitalWrite(ELECT_PURPLE_POS_ENB, temp);
  digitalWrite(ELECT_PURPLE_POS_POL, temp);
  
  digitalWrite(ELECT_GREY_NEG_ENB, temp);
  digitalWrite(ELECT_GREY_NEG_POL, temp);
  digitalWrite(ELECT_GREY_POS_ENB, temp);
  digitalWrite(ELECT_GREY_POS_POL, temp);
  
  digitalWrite(ELECT_WHITE_NEG_ENB, temp);
  digitalWrite(ELECT_WHITE_NEG_POL, temp);
  digitalWrite(ELECT_WHITE_POS_ENB, temp);
  digitalWrite(ELECT_WHITE_POS_POL, temp);
}

String getCurrents(){// get the values from the current sensor
  float currentBlack = ina219Black.getCurrent_mA();
  float currentBrown = ina219Brown.getCurrent_mA();
  float currentRed = ina219Red.getCurrent_mA();

  String temp = String(currentBlack,1) + ',' + String(currentBrown,1) + ',' + String(currentRed,1) + ',' + String(millis());

  return temp;
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == '\n') stringComplete = true;
    else inputString += inChar;
  }
}
