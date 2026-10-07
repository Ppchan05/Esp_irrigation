model PIDsystem
  Modelica.Blocks.Continuous.TransferFunction pump(b = {0.02777}, a = {0.3, 1}) annotation(
    Placement(transformation(origin = {-28, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = 0.1) annotation(
    Placement(transformation(origin = {30, -34}, extent = {{10, -10}, {-10, 10}})));
  SoilModel soilModel(h0 = 60, Ke = 0.0095, C = 0.12348) annotation(
    Placement(transformation(origin = {52, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator WaterConsumption annotation(
    Placement(transformation(origin = {-28, 68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID(yMax = 5, yMin = 0, k = 1, Ti = 1.05, Td = 0.236, withFeedForward = false, controllerType = Modelica.Blocks.Types.SimpleController.PID)  annotation(
    Placement(transformation(origin = {-42, -22}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant SetPoint(k = 80)  annotation(
    Placement(transformation(origin = {10, 2}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant T(k = 24)  annotation(
    Placement(transformation(origin = {18, 66}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(soilModel.W, pump.y) annotation(
    Line(points = {{40, 30}, {13.5, 30}, {13.5, 32}, {-17, 32}}, color = {0, 0, 127}));
  connect(soilModel.H, fixedDelay.u) annotation(
    Line(points = {{63, 30}, {80, 30}, {80, -34}, {42, -34}}, color = {0, 0, 127}));
  connect(WaterConsumption.u, pump.y) annotation(
    Line(points = {{-40, 68}, {-46, 68}, {-46, 32}, {-17, 32}}, color = {0, 0, 127}));
  connect(pump.u, PID.y) annotation(
    Line(points = {{-40, 32}, {-60, 32}, {-60, -22}, {-53, -22}}, color = {0, 0, 127}));
  connect(PID.u_s, SetPoint.y) annotation(
    Line(points = {{-30, -22}, {-20.5, -22}, {-20.5, 2}, {-1, 2}}, color = {0, 0, 127}));
  connect(fixedDelay.y, PID.u_m) annotation(
    Line(points = {{19, -34}, {-42, -34}}, color = {0, 0, 127}));
  connect(T.y, soilModel.T) annotation(
    Line(points = {{29, 66}, {40, 66}, {40, 38}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
    Diagram(graphics = {Polygon(origin = {-16, 18}, points = {{22, 34}, {22, 34}, {22, 34}})}),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 864, Tolerance = 1e-06, Interval = 0.001));
end PIDsystem;
