function [centroidmsg] = GenerateTargets(fileName)
%fileName - TargetProperties file
%centroidmsg - outputted centroids of each target over time
eval(fileName)
for n = 1:length(target)
    target(n).range = target(n).range * 1852; %Range in meters
    target(n).velocity = target(n).velocity * 0.5144; %Velocity in meters/second
    
    ship.range = ship.range * 1852; %Range in meters
    ship.velocity = ship.velocity * 0.5144; %Velocity in meters/second
    
    totalRevs = floor(totalTime/scanInterval);
    timeStamp = (0:totalRevs-1)* scanInterval;
    
    %Calculating Target x and y starting position
    target(n).x = target(n).range * sind(target(n).bearing);
    target(n).y = target(n).range * cosd(target(n).bearing);
    target(n).allx = zeros(length(timeStamp),1);
    target(n).ally = zeros(length(timeStamp),1);
    
    %Target heading at each time in timestamp
    instTargetHeading = target(n).heading + target(n).headingRate .* timeStamp;
    
    %Calculating target position at each time in timestamp and adding them to
    %allx and ally matrices
    for i = 1:length(timeStamp)
        target(n).allx(i) = target(n).x;
        target(n).ally(i) = target(n).y;
        target(n).x = target(n).x + target(n).velocity * sind(instTargetHeading(i)) * scanInterval;
        target(n).y = target(n).y + target(n).velocity * cosd(instTargetHeading(i)) * scanInterval;
    end
    
    %Calculating Ship x and y starting positions
    ship.x = ship.range * sind(ship.bearing);
    ship.y = ship.range * cosd(ship.bearing);
    ship.allx = zeros(length(timeStamp),1);
    ship.ally = zeros(length(timeStamp),1);
    
    %Ship heading at each time in timestamp
    instShipHeading = ship.heading + ship.headingRate .* timeStamp;
    
    %Calculating ship position at each time in timestamp and adding them to
    %allx and ally matrices
    for j = 1:length(timeStamp)
        ship.allx(i) = ship.x;
        ship.ally(i) = ship.y;
        ship.x = ship.x + ship.velocity * sind(instShipHeading(i)) * scanInterval;
        ship.y = ship.y + ship.velocity * cosd(instShipHeading(i)) * scanInterval;
    end
    
    %Range and bearing of target over time relative to the ship
    centroid(n).range = sqrt((target(n).allx-ship.allx).^2 + (target(n).ally-ship.ally).^2);
    centroid(n).bearing = mod(atan2(target(n).allx-ship.allx,target(n).ally-ship.ally) * 180/pi,360);


    centroidmsg(n).target = centroid(n);
end