Discrete PD & duty-cycles for ESP automated small-scale irrigation

This project compares threshold-based irrigation control against discrete PD with optimized duty cycles to reduce water consumption

LINKS: <br>
Summary: <br>
Full Document:<br>
Performance demonstration: <br>

SYSTEM ARCHITECTURE:<br>
Modeling: OpenModelica<br>
Microcontroller: ESP32 (Arduino framework/C++)<br>
Sensors & Actuators: LM393 soil moisture resistive probe, 3-6V submerged pump<br>
Circuit design: Darlington pair transistor switch designed in KiCad<br>
Control Theory: Discrete PD controller tuned using FODT simulations<br>
Communication: Publishing data via Adafruit MQTT before entering deep-sleep mode<br>

RESULTS:<br>
Threshold baseline: ~8.8% moisture overshoot<br>
PD control(second iteration): 3% moisture overshoot<br>
Eficiency: ~8% reduction in water consumption per cycle  <br>
