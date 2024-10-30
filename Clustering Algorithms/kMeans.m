function [idx,C, detections] = kMeans(data, k, rangeRes)
% data - inputted signal noise data
% k - number of clusters
% rangeRes - size of one range bin (meters)

% idx - all detections with number of cluster they are assigned to
% C - centroid locations

[pulse,rangeBin] = find(data==1);
detections = zeros(length(pulse),2);
pulseRes = 360/size(data,1);
detections(:,1) = (rangeBin * rangeRes) .* sind(pulse * pulseRes);
detections(:,2) = (rangeBin * rangeRes) .* cosd(pulse * pulseRes);
opts = statset('Display','final');
[idx,C] = kmeans(detections,k,'Distance','cityblock',...
    'Replicates',5,'Options',opts);
