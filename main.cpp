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




//task 02



