# EEPROM-duckduino

An EEPROM based duckduino -- for everyone who doesn´t own an sd card module.

For this to work, you need an arduino that can act like keyboard.

To programm the arduino, first upload the sketch to your arduino, the usToDE.h is a conversion table from english to german keycodes, altough it screws up some special keys. 
Enable it using the 'german' bool at the start of the code.
Then compile your script using the provided ahk script or compiled exe (keep in mind, that the script can´t be too big because of the limited EEPROM).
Then you need to connect pin 2 to ground, which enables programming mode, and plug your arduino into your PC.
Then just send the HEX values you got from the script in one piece over serial to the arduino and wait till it says Ready.
Now just deconnect pin 2 from ground and you´re good to go!

Notes and known limtations:

- Your antivirus programm might wrongfully identify the convert.exe as a virus
- Some keys like printscreen might not work, this is due to the limitations of the arduino keyboard library.