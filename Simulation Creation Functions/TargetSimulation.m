function [] = TargetSimulation(fileName,rangeRes,maxRange,numPulses)
%fileName - TargetProperties
%rangeRes - range resolution (size of one range bin)
%maxRange - maximum range (in nautical miles)
%numPulses - total number of pulses in 360 degree scan
%pwrData - outputted noise data with target signals
eval(fileName)
maxRange = maxRange * 1852; %Convert nautical miles to meters
numRangeBins = round(maxRange/rangeRes);
pulseRes = 360/numPulses;
noisePower = 10^6;
SNRPower = 10^9;
centroidmsg = GenerateTargets(fileName);
totalRevs = floor(totalTime/scanInterval);
timeStamp = (0:totalRevs-1)* scanInterval;
bearing = 0:pulseRes:360-pulseRes;
range = (0:numRangeBins-1) * rangeRes;
for n = 1:length(centroidmsg)
    centroidmsg(n).target.rangeBin = round(centroidmsg(n).target.range/rangeRes);
    centroidmsg(n).target.pulseNumber = round(centroidmsg(n).target.bearing/pulseRes);
end
targetRangeExtent = 10; %range length of the target from the centroid (in meters)
targetBearingExtent = 6; %bearing length of the target from the centroid (in degrees)
targetRangeExtentConv = round(targetRangeExtent/rangeRes); % Converting range extent to range bins
targetBearingExtentConv = round(targetBearingExtent/pulseRes); % Converting bearing extent to pulse number
for i = 1:length(timeStamp)
    complexNoise = sqrt(noisePower/2) * (randn(numPulses,numRangeBins) + sqrt(-1) * randn(numPulses,numRangeBins));
    pwrData = abs(complexNoise).^2;
    for j = 1:length(centroidmsg)
        startRangeInd = round(centroidmsg(j).target.rangeBin-targetRangeExtentConv/2);
        endRangeInd = round(centroidmsg(j).target.rangeBin+targetRangeExtentConv/2);
        startPulseInd = round(centroidmsg(j).target.pulseNumber-targetBearingExtentConv/2);
        endPulseInd = round(centroidmsg(j).target.pulseNumber+targetBearingExtentConv/2);
        pwrData(startPulseInd(i):endPulseInd(i), startRangeInd(i):endRangeInd(i)) = pwrData(startPulseInd(i):endPulseInd(i), startRangeInd(i):endRangeInd(i)) + SNRPower; 
    end
    imagesc(range/1852,bearing,10*log10(pwrData))
    xlabel('Range (Nmi)')
    ylabel('Bearing (Degrees)')
    caxis([60 90])
    colorbar
end