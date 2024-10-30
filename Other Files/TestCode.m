centroidmsg = GenerateTargets('TargetProperties');
TargetSimulation('TargetProperties', 2,30,800);
snr = Normalizer(11,36,pwrData);
T = 10 * log10(36 * ((1e-4^(-1/36))-1));
detections = snr>T;

%K-Means Code
[idx,C, kmeansData] = kMeans(detections, 4, 2);
figure;
plot(kmeansData(idx==1,1), kmeansData(idx==1,2), 'r.','MarkerSize',12)
hold on
plot(kmeansData(idx==2,1), kmeansData(idx==2,2), 'b.','MarkerSize',12)
plot(kmeansData(idx==3,1), kmeansData(idx==3,2), 'g.','MarkerSize',12)
plot(kmeansData(idx==4,1), kmeansData(idx==4,2), 'y.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2', 'Cluster 3', 'Cluster 4', 'Centroids',...
'Location','NW')
title 'Cluster Assignments and Centroids'

%Hierarchical Clustering Code
[idx,hierData] = hierarchical(detections, 0.1, 2);
gscatter(hierData(:,1),hierData(:,2),idx);
%Add legend manually since you don't know beforehand how many clusters
title 'Cluster Assignments and Centroids'

%DBSCAN  Code
[idx,dbData] = dbscanML(detections, 2, 5, 2);
gscatter(dbData(:,1),dbData(:,2),idx);
title 'Cluster Assignments and Centroids'