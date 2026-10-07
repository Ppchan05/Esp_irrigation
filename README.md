Discrete PD & duty-cycles for ESP automated small-scale irrigation

This project compares threshold-based irrigation control against discrete PD with optimized duty cycles to reduce water consumption

LINKS:
Summary: 
Full Document:
Performance demonstration: 

SYSTEM ARCHITECTURE:
Modeling: OpenModelica
Microcontroller: ESP32 (Arduino framework/C++)
Sensors & Actuators: LM393 soil moisture resistive probe, 3-6V submerged pump
Circuit design: Darlington pair transistor switch designed in KiCad
Control Theory: Discrete PD controller tuned using FODT simulations
Communication: Publishing data via Adafruit MQTT before entering deep-sleep mode

RESULTS:
Threshold baseline: ~8.8% moisture overshoot
PD control(second iteration): 3% moisture overshoot
Eficiency: ~8% reduction in water consumption per cycle  
