function [] = PlotTargetPosition(bearing,range)
%bearing - bearing of target over time in degrees
%range - range of target over time in meters
range = range/1852; %Convert to nautical miles
polar(bearing * pi/180, range)
view([90 -90])