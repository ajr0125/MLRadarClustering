
% ------------------------------------------------------------
% -- DESCRIPTION OF CODE                                    --
% ------------------------------------------------------------
% Inputs are expected as:
%
% 	(1) gap - number of guard cells around cell under test (CUT), should be
% 	odd
% 	(2) window - total window size of leading and lagging window, should be
% 	even
% 	(3) magnitude squared data to use   [numPulses x numRangeBins].
% 
% [noiseMean,mask1] = 
% Normalizer(gap, window, KVI, KMR, arcEnergyData)
%
% ************************************************************


function [snr] = Normalizer(gap, window, ...
			arcEnergyData)


% ------------------------------------------------------------
% -- Establish the size of the data and setup the           --
% -- extension of the data accordingly                      --
% ------------------------------------------------------------
halfWindow = window/2;
[numPulses, numRangeBins]   = size(arcEnergyData);
l_ext_l         = -((window/2)+(gap-1)/2)+window/2+gap+1;
l_ext_r         = -1 + window/2 + gap + 1;
r_ext_l         = numRangeBins - window/2 - gap + 1;
r_ext_r         = numRangeBins + window/2-1+(gap-1)/2-window/2-gap+1;

ext_data1      = [arcEnergyData(:,l_ext_l(1):l_ext_r(1)) arcEnergyData ...
                  arcEnergyData(:,r_ext_l(1):r_ext_r(1))];
snr = zeros(numPulses,numRangeBins); 
halfGap = (gap-1)/2;

%Window Size + 1 Bin for Target + Gap Bins on Each Side of Target
iWindow=1:window+1+2*halfGap;
shiftCFAR=(0:numRangeBins-1).';
index=repmat(iWindow,numRangeBins,1)+repmat(shiftCFAR,1,window+1+2*halfGap);
    
%Linear Index for the reference window
iLead=index(:,1:window/2);
iLag=index(:,window/2+2*halfGap+2:end);
tic
for bm = 1:numPulses
    bm
    signal = ext_data1(bm,:);

    %Lead and Lag Window Indices
    leadWin=signal(iLead);
    lagWin=signal(iLag);
    
    %Calculate mean of lead and lag window
    meanLead = mean(leadWin,2);
    meanLag = mean(lagWin,2);
    
    %Mean of lead and lag window means is the noise mean estimate
    noiseMean = (meanLead+meanLag)/2;
    snr(bm,:) = 10 * log10(arcEnergyData(bm,:)./noiseMean');
end
        
toc