model FOPDTparameters
  Modelica.Blocks.Continuous.TransferFunction pump(a = {0.3, 1}, b = {0.005554}) annotation(
    Placement(transformation(origin = {-31, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 5, startTime = 0) annotation(
    Placement(transformation(origin = {-64, 22}, extent = {{-10, -10}, {10, 10}})));
  SoilModel soilModel(h0 = 60, Ke = 0.0095, C = 0.12348)  annotation(
    Placement(transformation(origin = {4, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant Temp(k = 24)  annotation(
    Placement(transformation(origin = {-44, 62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 100, uMin = 0)  annotation(
    Placement(transformation(origin = {74, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.FixedDelay SensorDelay(delayTime = 0.1)  annotation(
    Placement(transformation(origin = {36, 22}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(pump.u, step.y) annotation(
    Line(points = {{-43, 22}, {-53, 22}}, color = {0, 0, 127}));
  connect(soilModel.W, pump.y) annotation(
    Line(points = {{-8, 22}, {-20, 22}}, color = {0, 0, 127}));
  connect(Temp.y, soilModel.T) annotation(
    Line(points = {{-33, 62}, {-33, 44.5}, {-8, 44.5}, {-8, 29}}, color = {0, 0, 127}));
  connect(soilModel.H, SensorDelay.u) annotation(
    Line(points = {{16, 22}, {24, 22}}, color = {0, 0, 127}));
  connect(SensorDelay.y, limiter.u) annotation(
    Line(points = {{48, 22}, {62, 22}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.001));
end FOPDTparameters;
