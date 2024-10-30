function [idx, detections] = hierarchical(data, x, rangeRes)
% data - inputted signal noise data
% x - inconsistency threshold (dendrogram cutoff point)
% rangeRes - size of one range bin (meters)

% idx - all detections with number of cluster they are assigned to

[pulse,rangeBin] = find(data==1);
detections = zeros(length(pulse),2);
pulseRes = 360/size(data,1);
detections(:,1) = (rangeBin * rangeRes) .* sind(pulse * pulseRes);
detections(:,2) = (rangeBin * rangeRes) .* cosd(pulse * pulseRes);

distances = squareform(pdist(detections));
clusterTree = linkage(distances);
idx = cluster(clusterTree, "cutoff", x);
