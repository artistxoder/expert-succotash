#include <DHT.h>           // DHT sensor library
#include <Wire.h>          // Required for I2C communication (OLED)
#include <Adafruit_GFX.h>  // Core graphics library (OLED)
#include <Adafruit_SSD1306.h> // OLED display driver

// --- DHT11 Sensor Definitions ---
#define DHTPIN 3           // DHT11 data pin connected to Arduino pin 3
#define DHTTYPE DHT11      // Sensor type: DHT11

// Create DHT object
DHT dht(DHTPIN, DHTTYPE);

// --- MQ-2 Gas Sensor Definition ---
#define MQ2_PIN A0         // MQ-2 Analog output pin connected to Arduino pin A0

// --- Buzzer and LED Pins ---
#define BUZZER_PIN 8       // Buzzer (+) pin connected to Arduino pin 8
#define LED_PIN 9          // LED (+) pin connected to Arduino pin 9

// --- OLED Display Definitions ---
#define SCREEN_WIDTH 128   // OLED display width, in pixels
#define SCREEN_HEIGHT 64   // OLED display height, in pixels
#define OLED_RESET -1      // Reset pin # (or -1 if sharing Arduino reset pin)

// Create the SSD1306 display object
// The address depends on your specific OLED module. Common addresses are 0x3C or 0x3D.
// You might need to change this if your display doesn't work.
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// --- System Thresholds and Settings ---
int gasThreshold = 300;    // Gas threshold value (adjust higher = less sensitive, lower = more sensitive)
bool useFahrenheit = true; // Temperature scale: true = Fahrenheit, false = Celsius

void setup() {
  // Initialize Serial communication for debugging
  Serial.begin(9600);

  // Initialize DHT sensor
  dht.begin();
  
  // Initialize OLED display (address 0x3C or 0x3D)
  // ssd1306_128_64 is the resolution. Check your display.
  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) { 
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }

  // Clear the display buffer.
  display.clearDisplay();
  // Set text size to 1 (smallest)
  display.setTextSize(1);
  // Set text color to white
  display.setTextColor(SSD1306_WHITE);
  // Set cursor to (0,0) (top-left corner)
  display.setCursor(0,0);
  // Print welcome message to OLED
  display.println(F("System Initializing..."));
  display.display(); // Show the splashscreen buffer on the display

  // Pin mode setup
  pinMode(MQ2_PIN, INPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);

  // Initial warming up for MQ-2 sensor (crucial for accurate readings)
  Serial.println("Warming up MQ-2 sensor for 20 seconds...");
  display.setCursor(0, 10);
  display.println(F("MQ-2 Warming up..."));
  display.display();
  delay(20000); 
  Serial.println("System Ready!");
  display.clearDisplay();
  display.setCursor(0,0);
  display.println(F("System Ready!"));
  display.display();
  delay(1000); // Display "System Ready!" for a moment
}

void loop() {
  // Clear the display for new readings
  display.clearDisplay();

  // --- Read MQ-2 Sensor ---
  // Smooth gas reading by averaging 5 samples to reduce noise
  long totalGas = 0;
  for (int i = 0; i < 5; i++) {
    totalGas += analogRead(MQ2_PIN);
    delay(10); // Small delay between readings
  }
  int gasValue = totalGas / 5;

  // --- Read DHT11 Sensor ---
  float humidity = dht.readHumidity();
  // Read temperature based on the 'useFahrenheit' setting
  float temperature = useFahrenheit ? dht.readTemperature(true) : dht.readTemperature();

  // Check if any DHT sensor reading failed
  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Error: Failed to read from DHT11 sensor!");
    display.setCursor(0,0);
    display.println(F("DHT11 Error!"));
    display.display();
    delay(2000); // Display error for 2 seconds
    return; // Skip the rest of the loop if sensor read fails
  }

  // --- Display Readings on Serial Monitor ---
  Serial.print("Gas: "); Serial.print(gasValue);
  Serial.print(" | Humidity: "); Serial.print(humidity); Serial.print("%");
  Serial.print(" | Temp: "); Serial.print(temperature);
  Serial.println(useFahrenheit ? "°F" : "°C");

  // --- Display Readings on OLED ---
  // Display Gas Value
  display.setTextSize(2); // Larger text for main readings
  display.setCursor(0,0);
  display.print(F("Gas: "));
  display.println(gasValue);

  // Display Temperature
  display.setCursor(0, 24); // Move cursor down for next line
  display.print(F("Temp: "));
  display.print(temperature);
  display.print(useFahrenheit ? (char)247 : " "); // Degree symbol (char 247 for some fonts) or space
  display.println(useFahrenheit ? "F" : "C");

  // Display Humidity
  display.setCursor(0, 48); // Move cursor down again
  display.print(F("Hum: "));
  display.print(humidity);
  display.println(F("%"));

  // Show the updated buffer on the display
  display.display();

  // --- Gas Alarm Trigger ---
  if (gasValue > gasThreshold) {
    digitalWrite(BUZZER_PIN, HIGH); // Turn buzzer ON
    digitalWrite(LED_PIN, HIGH);    // Turn LED ON
    Serial.println("!!! GAS DETECTED !!!");
    // Optionally, display alarm on OLED if space allows or in a separate screen
    // display.setCursor(0,0); display.println("GAS ALARM!"); display.display();
  } else {
    digitalWrite(BUZZER_PIN, LOW);  // Turn buzzer OFF
    digitalWrite(LED_PIN, LOW);     // Turn LED OFF
  }

  delay(1000); // Wait for 1 second before next reading
}

