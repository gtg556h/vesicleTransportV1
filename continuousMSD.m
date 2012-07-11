function [MSD, meanLogSlope, tau, xPosShort, yPosShort, t] = continuousMSD(xPos, yPos, maxTau, slopeMin, slopeMax, dt)

startIndex = round(maxTau/2/dt);
lengthVec = length(xPos);


for ii = startIndex + 1:lengthVec - startIndex
    xVec = xPos(ii-startIndex:ii+startIndex);
    yVec = yPos(ii-startIndex:ii+startIndex);
    [MSDx{ii}, MSDy{ii}, tau{ii}] = MSDcalc(xVec,yVec,dt);
    MSD{ii} = sqrt(MSDx{ii}.^2 + MSDy{ii}.^2);
    %[slope, intercept] = logfit(tau{ii}(slopeMin/dt:slopeMax/dt),MSD{ii}(slopeMin/dt:slopeMax/dt),'loglog');
    %meanLogSlope(ii) = slope;
    %meanLogSlope(ii) = log(MSD{ii}(slopeMax/dt)/MSD{ii}(slopeMin/dt))/log(slopeMax/slopeMin);
    linFit = polyfit(log(tau{ii}(slopeMin/dt:slopeMax/dt))',log(MSD{ii}(slopeMin/dt:slopeMax/dt)),1);
    meanLogSlope(ii) = linFit(1);
    
end
% Note: MSD cell array contains empty vectors for 1:startIndex.  Not
% important

% Truncate meanLogSlope and xPos, yPos to get rid of startIndex:

xPosShort = xPos(startIndex+1:lengthVec-startIndex);
yPosShort = yPos(startIndex+1:lengthVec-startIndex);
meanLogSlope = meanLogSlope(startIndex+1:lengthVec-startIndex);
t = 0:dt:(length(xPosShort)-1)*dt;