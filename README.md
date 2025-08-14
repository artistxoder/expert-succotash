# Arduino MQ-2 Gas + DHT11 Temp/Humidity Monitor with 3D Printed Case

A combined gas detection and climate monitoring project using Arduino UNO, MQ-2 gas sensor, and DHT11 temperature/humidity sensor. This project includes a **100% screw-free 3D printable case** designed for easy assembly and optimal component integration, complete with buzzer and LED alarms.

## Acknowledgements

Gemini, ChatGPT, and Claude were used to generate, refine, and improve the OpenSCAD code, making it more modular and parametric. The conceptual wiring diagram was also created with the assistance of these AI models.

## 📦 Features

* Detects gas/smoke using `MQ-2` sensor.
* Measures temperature and humidity with `DHT11`.
* Buzzer + LED alerts when gas exceeds a set threshold.
* Option to display temperature in Celsius or Fahrenheit.
* Smoothed gas readings for better accuracy.
* **Custom 3D Printed Enclosure:** A two-part case (main body + lid) with integrated mounts.
* **100% Screw-Free Design:** All components are held in place with snap-fits and friction mounts.

## 🛠 Hardware Required

* Arduino UNO (or compatible)
* MQ-2 Gas Sensor
* DHT11 Temperature/Humidity Sensor
* Active Buzzer
* LED + Resistor (220Ω)
* Jumper Wires
* Mini Breadboard (recommended for prototyping, mounts directly into case)

## 📐 Circuit Diagram

| Arduino Pin | Component               |
| :---------- | :---------------------- |
| A0          | MQ-2 Analog Output      |
| 3           | DHT11 Data Pin          |
| 8           | Buzzer (+)              |
| 9           | LED (+ via resistor)    |
| GND         | All Components GND      |
| 5V          | MQ-2 + DHT11 VCC        |

## 📄 How It Works

1.  `MQ-2` detects gas concentration.
2.  `DHT11` reads temperature and humidity.
3.  Values are printed to Serial Monitor.
4.  If gas exceeds the set threshold, the buzzer sounds and the LED turns on.

## 🔧 Setup Instructions

1.  **Install the `DHT sensor library` in Arduino IDE:**
    * Go to `Sketch > Include Library > Manage Libraries...`
    * Search for `DHT sensor library by Adafruit` and install.
2.  Connect components according to the wiring diagram.
3.  Upload the code from `mq2_dht11.ino` to your Arduino.
4.  Open Serial Monitor (9600 baud) to view live data.

## 🖨️ 3D Printable Case

This project includes a custom 3D printed case designed to house all the components neatly. The design is optimized for smaller FDM 3D printers, specifically the **EasyThreed K7 Mini (100x100x100mm build volume)**.

### **Available Files:**

* **`STL/case_main.stl`**: The main body of the enclosure.
* **`STL/case_lid.stl`**: The snap-fit lid.

### **Printing Tips for K7 Mini (and similar small FDM printers):**

* **Printer Compatibility:** Designed for **100x100x100mm** print beds. The `case_width` in the OpenSCAD file has been adjusted to `98mm` to fit your K7 Mini perfectly with a small margin.
* **Layer Height:** Use `0.2mm` layer height for a good balance of detail and print time.
* **Filament:** `PLA` is recommended. The original design was optimized for Red PLA.
* **Supports:** The case is designed to be printed **without supports**. Verify this in your slicer.
* **Infill:** `15-20%` infill (e.g., Grid or Gyroid pattern) is generally sufficient.
* **Bed Adhesion:** Due to the K7 Mini typically not having a heated bed, strong bed adhesion is crucial to prevent warping, especially for the main case body. Consider using a `glue stick`, `blue painter's tape`, or `hair spray` on your print bed.
* **Temperatures:** Refer to your filament manufacturer's recommendations. A common starting point for PLA is `200-210°C` for the nozzle.

### **Assembly:**

1.  Print both `case_main.stl` and `case_lid.stl` separately.
2.  The Arduino mounts via snap-fit posts inside the main case.
3.  The mini breadboard slides into a friction-fit mount.
4.  Sensors (MQ-2, DHT11) and outputs (Buzzer, LED) have dedicated slots and mounts.
5.  Route wires through the internal management channels.
6.  Once all components are installed and wired, the lid snaps securely onto the main case.

## 📐 CAD Source Files

The `.scad` file (`CAD/case.scad`) contains the full parametric design of the enclosure. You can open and modify this file using **OpenSCAD** (available for free at [openscad.org](https://openscad.org)).

* **Parametric Design:** The design is highly parametric. You can easily adjust dimensions like `tolerance`, `wall_thickness`, or reposition components by editing variables at the top of the `.scad` file.
* **Tolerance Adjustment:** If the snap-fit or friction-fit parts are too tight or too loose after printing, adjust the `tolerance` variable in the `.scad` file. Increase it for looser fits, decrease for tighter fits.
* **Why No G-code?** G-code is highly specific to a particular 3D printer model, its firmware, nozzle size, and even the exact filament type. Providing G-code would limit the project's usability to only those with identical setups. By providing the `.scad` and `.stl` files, you can generate optimized G-code for your specific printer and settings using your preferred slicer software (e.g., Cura, PrusaSlicer).

## ⚖ License

This project is licensed under the MIT License — you are free to use, modify, and distribute.

## 🤝 Contributing

Pull requests are welcome. For major changes or new features, please open an issue first to discuss ideas and potential implementations.

## 📢 Author

Created by Garrett Goben – inspired by DIY electronics and IoT safety devices.
