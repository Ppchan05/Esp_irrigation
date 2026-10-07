model TryingToDoPump
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = 30, uHigh = 70)  annotation(
    Placement(transformation(origin = {-12, -20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(transformation(origin = {-56, -20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant GND(k = 0)  annotation(
    Placement(transformation(origin = {-52, -78}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant Supply(k = 5)  annotation(
    Placement(transformation(origin = {-52, -48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.TransferFunction pump(b = {0.005554}, a = {0.3, 1})  annotation(
    Placement(transformation(origin = {-36, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = 0.1)  annotation(
    Placement(transformation(origin = {36, -20}, extent = {{10, -10}, {-10, 10}})));
  SoilModel soilModel(h0 = 30, Ke = 0.0095, C = 0.12348)  annotation(
    Placement(transformation(origin = {52, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator WaterConsumption annotation(
    Placement(transformation(origin = {-28, 68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant T(k = 24)  annotation(
    Placement(transformation(origin = {14, 66}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(switch.u2, hysteresis.y) annotation(
    Line(points = {{-44, -20}, {-23, -20}}, color = {255, 0, 255}));
  connect(switch.u1, GND.y) annotation(
    Line(points = {{-44, -12}, {-30.5, -12}, {-30.5, -78}, {-41, -78}}, color = {0, 0, 127}));
  connect(switch.u3, Supply.y) annotation(
    Line(points = {{-44, -28}, {-34, -28}, {-34, -48}, {-40, -48}}, color = {0, 0, 127}));
  connect(pump.u, switch.y) annotation(
    Line(points = {{-48, 30}, {-80, 30}, {-80, -20}, {-66, -20}}, color = {0, 0, 127}));
  connect(soilModel.W, pump.y) annotation(
    Line(points = {{40, 30}, {-24, 30}}, color = {0, 0, 127}));
  connect(soilModel.H, fixedDelay.u) annotation(
    Line(points = {{63, 30}, {80, 30}, {80, -20}, {48, -20}}, color = {0, 0, 127}));
  connect(hysteresis.u, fixedDelay.y) annotation(
    Line(points = {{0, -20}, {25, -20}}, color = {0, 0, 127}));
  connect(WaterConsumption.u, pump.y) annotation(
    Line(points = {{-40, 68}, {-46, 68}, {-46, 44}, {-24, 44}, {-24, 30}}, color = {0, 0, 127}));
  connect(soilModel.T, T.y) annotation(
    Line(points = {{40, 38}, {26, 38}, {26, 66}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(graphics = {Polygon(points = {{22, 34}, {22, 34}})}),
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
  experiment(StartTime = 0, StopTime = 864, Tolerance = 1e-06, Interval = 0.001));
end TryingToDoPump;
