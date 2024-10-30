ship.range = 0; %Range in Nautical miles
ship.bearing = 0;
ship.velocity = 50; %Velocity in Knots (Nautical miles/hr)
ship.heading = 30;
ship.headingRate = 0.5; %In degrees/second

target(1).range = 5;
target(1).bearing = 45;
target(1).velocity = 60; 
target(1).heading = 180;
target(1).headingRate = 1; 

target(2).range = 2; 
target(2).bearing = 225;
target(2).velocity = 80;
target(2).heading = 30;
target(2).headingRate = 0.25; 

target(3).range = 1; 
target(3).bearing = 135;
target(3).velocity = 90; 
target(3).heading = 135;
target(3).headingRate = 0; 

target(4).range = 3; 
target(4).bearing = 315;
target(4).velocity = 70; 
target(4).heading = 180;
target(4).headingRate = 0.5;

scanInterval = 1; %scanInterval - time for one revolution of tracker in seconds
totalTime = 120; %totalTime - total time scanning for in seconds
