# expert-succotash
# 🔥 Arduino UNO MQ-2 Gas Sensor + OLED Display with Custom 3D Printed Case

An **Arduino-based gas detection system** using the MQ-2 sensor and an SSD1306 OLED display, all housed in a custom 3D-printed case.  
Detects **LPG, methane, smoke, and other gases** and displays real-time readings on the screen.

![Wiring Diagram](wiring-diagram.png)  
![3D Printed Case](case-photo.png)  

---

## ✨ Features
- **Real-time gas detection** with MQ-2 sensor
- **OLED display** (SSD1306) for live readings
- Compact, **snap-fit 3D printed case** (optimized for K7 Mini printer & red PLA)
- Fully customizable — change dimensions, code, or case color
- Open source hardware & software

---

## 🛠 Components Used
- Arduino UNO (or compatible)
- MQ-2 gas sensor
- 0.96" SSD1306 OLED display (I²C)
- Breadboard & jumper wires
- 3D printed case (OpenSCAD design)

---

## 🔌 Wiring Guide

| MQ-2 Pin | Arduino Pin |
|----------|------------|
| VCC      | 5V         |
| GND      | GND        |
| A0       | A0         |
| D0       | D2         |

| OLED Pin | Arduino Pin |
|----------|------------|
| VCC      | 5V         |
| GND      | GND        |
| SDA      | A4         |
| SCL      | A5         |

---

## 📜 Arduino Code
```cpp
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

#define MQ2_A0 A0

void setup() {
  Serial.begin(9600);

  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;);
  }
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
}

void loop() {
  int sensorValue = analogRead(MQ2_A0);

  display.clearDisplay();
  display.setCursor(0, 0);
  display.print("Gas Level:");
  display.setCursor(0, 20);
  display.setTextSize(2);
  display.print(sensorValue);
  display.display();

  delay(500);
}
