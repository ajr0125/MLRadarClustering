function [idx, detections] = dbscanML(data, epsilon, minpts, rangeRes)
% data - inputted signal noise data
% epsilon - circle border radius
% minpts - minimum points needed to establish a core point
% rangeRes - size of one range bin (meters)

% idx - all detections with number of cluster they are assigned to

[pulse,rangeBin] = find(data==1);
detections = zeros(length(pulse),2);
pulseRes = 360/size(data,1);
range = rangeBin * rangeRes;
bearing = pulse * pulseRes;
polar(bearing * pi/180, range/1852)
detections(:,1) = (range) .* sind(bearing);
detections(:,2) = (range) .* cosd(bearing);

figure;
plot(detections(:,1), detections(:,2), 'rx')
idx = dbscan(detections, epsilon, minpts, 'Distance', 'squaredeuclidean');