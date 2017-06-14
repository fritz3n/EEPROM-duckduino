
#include <EEPROM.h>
#include <Keyboard.h>
#include "usToDE.h"

const bool german = 1;
bool progmode = false;
bool led = HIGH;
unsigned long lastmills = 0;
int lastpos;
int repnum = -1;
int defdel = 0;
int count;
byte cur;
const int progPin = 2;
String temp;
void setup() {
    Serial.begin(9600);
    pinMode(progPin,INPUT_PULLUP);
    pinMode(LED_BUILTIN,OUTPUT);
    if(digitalRead(progPin) == HIGH){
      Keyboard.begin();
      delay(100);
      digitalWrite(LED_BUILTIN,HIGH);
      count = 0;
      while(count <= 1023){
        cur = EEPROM.read(count);
        switch(cur){
          case 0:
            count = 1024;
            break;
          break;

          case 2:
            lastpos = cur;
            count++;
            defdel = EEPROMReadInt(count);
            count += 2;
          break;

          case 3:
            lastpos = cur;
            count++;
            delay(EEPROMReadInt(count));
            count += 2;
          break;

          case 4:
          lastpos = cur;
          temp = "";
          while(count <= 1023){
            count++;
            cur = EEPROM.read(count);
            if(cur != 0){
              char a = cur;
              if(german){
                char a = (usToDE[a]);
              }
              temp += String(a);
            }else{
              break;
            }
          }
          if(temp != ""){
            //Serial.println(temp);
            Keyboard.print(temp);
          }
          count++;
          break;

          case 5:
          lastpos = cur;
          while(count <= 1023){
            count++;
            cur = EEPROM.read(count);
             if(cur != 0){
               if(EEPROM.read(count+1)!=0){
                  Keyboard.press(cur);
               }else{
                  Keyboard.write(cur);
               }
             }else{
                break;
             }
            }
            count++;
            Keyboard.releaseAll();
            break;

            case 6:
              count++;
              if(repnum>0){
                repnum--;
                count = lastpos;
              }else if(repnum == 0){
                repnum = -1;
              }else if(repnum == -1){
                repnum = EEPROM.read(count)-1;
                count = lastpos;
              }
              count++;
            break;
        }
        if(defdel != 0){
          delay(defdel);
        }
      }
      digitalWrite(LED_BUILTIN,LOW);
      Keyboard.end();
    }else{
      progmode = true;
    }
}

void loop() {
  if(progmode){
    if(millis()-lastmills >= 500){
      led = !led;
      digitalWrite(LED_BUILTIN,led);
      lastmills = millis();
    }
    if (Serial.available() > 0) {
      //Serial.println("new Programm:");
      for(int i=0; i<=1023; i++) {
          delay(10);
          char hexAr[3];
          int hex = Serial.readBytesUntil(' ',hexAr,10);
          //Serial.print("-- ");
          //Serial.println(hex);
          if(hex == 2){
            hexAr[hex] = '\0';
            int valint = StrToHex(hexAr);
            byte val = (byte) valint;
            EEPROM[ i ] = val;
            Serial.print(i);
            Serial.print("\t");
            Serial.println(EEPROM.read(i));
          }else{
            Serial.println("Ready");
            break;
          }
          
      }
      Serial.end(); // Ends the serial communication once all data is received
      delay(500);
      Serial.begin(9600);  // Re-establishes serial communication , this causes deletion of anything previously stored in 
    }
  }
}

int StrToHex(char str[]){
  return (int) strtol(str, 0, 16);
}

unsigned int EEPROMReadInt(int p_address){
     byte lowByte = EEPROM.read(p_address);
     byte highByte = EEPROM.read(p_address + 1);

     return ((highByte << 0) & 0xFF) + ((lowByte << 8) & 0xFF00);
}
