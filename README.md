Discrete PD & duty cycles for ESP32 automated small-scale irrigation

This project compares threshold-based irrigation control against discrete PD with optimized duty cycles to reduce water consumption.

LINKS: <br>
Summary: [Google Drive](https://drive.google.com/file/d/1opUbFz7Rgay45Kw-4ME0JdJNk1bW7KVy/view?usp=sharing)<br>
Full Document:<br>
Performance demonstration: <br>

SYSTEM ARCHITECTURE:<br>
Modeling: OpenModelica<br>
Microcontroller: ESP32 (Arduino framework / C++)<br>
Sensors & Actuators: LM393 soil moisture resistive probe, 3-6V submerged pump<br>
Circuit Design: Darlington pair transistor switch designed in KiCad<br>
Control Theory: Discrete PD controller tuned using FODT simulations<br>
Communication: Publishing data via Adafruit MQTT before entering deep-sleep mode<br>

RESULTS:<br>
Threshold baseline: ~8.8% moisture overshoot<br>
PD control (second iteration): 3% moisture overshoot<br>
Efficiency: ~8% reduction in water consumption per cycle  <br>

REPOSITORY STRUCTURE: <br>
```text
├──Software/
│       └──Main/
│             └──main.ino    # Main ESP32 firmware with control logic & deep-sleep
├──Models/
│       ├──FOPDTparameters.mo    # First-Order Plus Dead-Time model of plant  
│       ├──PID system.mo    # PID and PD closed loops
│       ├──SoilModel.mo    # Soil block
│       └──Threshold system.mo    # Threshold closed loop
└──Hardware/
        ├──Datasheets/    # Datasheets for circuit transistors
        │          ├──2N2222.pdf
        │          └──2sd1207.pdf
        └──Schematic/
                   ├──System interconnections.kicad_sch    # KiCAD schematic file
                   └──System interconnections.pdf    # High resolution exported file
