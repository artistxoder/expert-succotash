#include <DHT.h>        // DHT sensor library
#define DHTPIN 3        // DHT11 data pin connected to Arduino pin 3
#define DHTTYPE DHT11   // Sensor type: DHT11

// Create DHT object
DHT dht(DHTPIN, DHTTYPE);

// MQ-2 Sensor pin
#define MQ2_PIN A0      

// Buzzer and LED pins
#define BUZZER_PIN 8    
#define LED_PIN 9       

// Gas threshold value (adjust to your needs)
int gasThreshold = 300; // Higher = less sensitive

// Temperature scale: true = Fahrenheit, false = Celsius
bool useFahrenheit = true;

void setup() {
  Serial.begin(9600);
  dht.begin();
  
  pinMode(MQ2_PIN, INPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);

  Serial.println("Initializing System...");
  Serial.println("Warming up MQ-2 sensor for 20 seconds...");
  delay(20000); // MQ-2 needs time to warm up for accurate readings
  Serial.println("System Ready!");
}

void loop() {
  // Smooth gas reading over 5 samples
  long totalGas = 0;
  for (int i = 0; i < 5; i++) {
    totalGas += analogRead(MQ2_PIN);
    delay(10);
  }
  int gasValue = totalGas / 5;

  // Read temperature & humidity
  float humidity = dht.readHumidity();
  float temperature = useFahrenheit ? dht.readTemperature(true) : dht.readTemperature();

  // Check for DHT errors
  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Error: Failed to read from DHT11 sensor!");
    return;
  }

  // Display readings
  Serial.print("Gas: "); Serial.print(gasValue);
  Serial.print(" | Humidity: "); Serial.print(humidity); Serial.print("%");
  Serial.print(" | Temp: "); Serial.print(temperature);
  Serial.println(useFahrenheit ? "°F" : "°C");

  // Gas alarm trigger
  if (gasValue > gasThreshold) {
    digitalWrite(BUZZER_PIN, HIGH);
    digitalWrite(LED_PIN, HIGH);
  } else {
    digitalWrite(BUZZER_PIN, LOW);
    digitalWrite(LED_PIN, LOW);
  }

  delay(1000);
}
