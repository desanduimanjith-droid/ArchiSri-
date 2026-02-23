#include <Arduino.h>

// // Most ESP32 DevKits have the built-in LED on GPIO 2
// #define LED_PIN 2

// void setup() {
//     // Initialize serial communication at 115200 baud
//     Serial.begin(115200);
    
//     // Set the LED pin as an output
//     pinMode(LED_PIN, OUTPUT);
    
//     Serial.println("--- ArchiSRI System Test Starting ---");
//     Serial.println("If you see this, your USB Driver is working!");
// }

// void loop() {
//     // Turn the LED on
//     digitalWrite(LED_PIN, HIGH);
//     Serial.println("LED ON");
//     delay(1000); // Wait for 1 second
    
//     // Turn the LED off
//     digitalWrite(LED_PIN, LOW);
//     Serial.println("LED OFF");
//     delay(1000); // Wait for 1 second
// }

// Capacitive Soil Moisture Sensor Test

//   // Read the analog value (0 to 4095 on ESP32)
//   int rawValue = analogRead(sensorPin);
  
//   // Note: Capacitive sensors read HIGHER values when DRY 
//   // and LOWER values when WET.
//   Serial.print("Raw Sensor Value: ");
//   Serial.println(rawValue);

//   delay(1000); 
#include <Arduino.h>

// 1. Identify the Pin
const int sensorPin = 34; // Yellow wire connected to D34

// 2. Set Calibration Values (Adjust WET_VALUE after your water test!)
const int DRY_VALUE = 3270; // Value when sensor is in the air
const int WET_VALUE = 1200; // Value when sensor is in water

void setup() {
  // Start Serial at 115200 to match your platformio.ini
  Serial.begin(115200);
  delay(1000);
  Serial.println("--- Soil Moisture Sensor Online ---");
}

void loop() {
  // Read the analog signal (0 - 4095) from the sensor
  int rawValue = analogRead(sensorPin);
  
  // Map the raw value to a 0-100% scale
  // Because it's capacitive: DRY_VALUE = 0% and WET_VALUE = 100%
  int moisturePercent = map(rawValue, DRY_VALUE, WET_VALUE, 0, 100);

  // Constrain ensures the value stays between 0 and 100
  moisturePercent = constrain(moisturePercent, 0, 100);

  // Print the results to the Serial Monitor
  Serial.print("Raw Value: ");
  Serial.print(rawValue);
  Serial.print(" | Moisture Level: ");
  Serial.print(moisturePercent);
  Serial.println("%");

  // Wait 1 second before the next reading
  delay(1000);
}



// #define RE_DE_PIN 4

// // Standard Modbus RTU request for Address 0x01, Read 1 Register starting at 0x0000
// const byte moistureRequest[] = {0x01, 0x03, 0x00, 0x00, 0x00, 0x01, 0x84, 0x0A};
// byte sensorResponse[7]; 

// void setup() {
//   Serial.begin(115200);
//   Serial2.begin(9600, SERIAL_8N1, 16, 17); // Most sensors use 9600 baud
//   pinMode(RE_DE_PIN, OUTPUT);
//   digitalWrite(RE_DE_PIN, LOW);
//   Serial.println("Soil Sensor Initialized...");
// }

// void loop() {
//   digitalWrite(RE_DE_PIN, HIGH); // Talk mode
//   delay(10);
//   Serial2.write(moistureRequest, sizeof(moistureRequest));
//   Serial2.flush();
//   digitalWrite(RE_DE_PIN, LOW); // Listen mode

//   unsigned long startTime = millis();
//   int byteCount = 0;

//   // Wait up to 500ms for response
//   while (millis() - startTime < 500) {
//     if (Serial2.available()) {
//       sensorResponse[byteCount++] = Serial2.read();
//     }
//     if (byteCount == 7) break; 
//   }

//   if (byteCount == 7) {
//     // Industrial sensors often return values multiplied by 10
//     int rawMoisture = (sensorResponse[3] << 8) | sensorResponse[4];
//     float moisturePercent = rawMoisture * 0.1; 
    
//     Serial.print("Soil Moisture: ");
//     Serial.print(moisturePercent);
//     Serial.println("%");
//   } else {
//     Serial.println("Error: No response from sensor. Check wiring/power.");
//   }

//   delay(2000);
// }


// // Basic RS485 Communication Test for ESP32
// #define RE_DE_PIN 4  // Connects to both RE and DE pins

// void setup() {
//   Serial.begin(115200);          // For Serial Monitor
//   Serial2.begin(9600, SERIAL_8N1, 16, 17); // RS485 on pins 16(RX) and 17(TX)
  
//   pinMode(RE_DE_PIN, OUTPUT);
//   digitalWrite(RE_DE_PIN, LOW); // Start in "Listening" mode
  
//   Serial.println("RS485 Test Initialized...");
// }

// void loop() {
//   // Sending a test message out through the RS485 module
//   digitalWrite(RE_DE_PIN, HIGH); // Switch to "Talking" mode
//   Serial2.print("Testing RS485...");
//   delay(10); 
//   digitalWrite(RE_DE_PIN, LOW);  // Switch back to "Listening" mode
  
//   Serial.println("Sent: Testing RS485...");
  
//   // If you have a sensor connected, it would reply here
//   while (Serial2.available()) {
//     char inChar = (char)Serial2.read();
//     Serial.print("Received: ");
//     Serial.println(inChar);
//   }
  
//   delay(2000);
// }

//task 02


