block SoilModel
parameter Real h0 = 90 "initial humidity";
parameter Real Ke = 0.0095 "evaporation coefficient";
parameter Real C = 2 "Soil capacity";
  Modelica.Blocks.Interfaces.RealOutput H (max = 100, min = 0) annotation(
    Placement(transformation(origin = {108, -2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput W annotation(
    Placement(transformation(origin = {-106, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T annotation(
    Placement(transformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}})));
initial equation
H = h0;
equation
  der(H) = (W/C)*100 - (T*Ke)/3600 "soil model";
  annotation(
    uses(Modelica(version = "4.0.0")),
  experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 1));
end SoilModel;
