function [MSD, meanLogSlope, tau, xPos, yPos, t] = continuousMSD(xPos, yPos, maxTau, slopeMin, slopeMax, dt)

startIndex = round(maxTau/2/dt);
lengthVec = length(xPos);


for ii = startIndex + 1:lengthVec - startIndex
    xVec = xPos(ii-startIndex:ii+startIndex);
    yVec = yPos(ii-startIndex:ii+startIndex);
    [MSDx{ii}, MSDy{ii}, tau{ii}] = MSDcalc(xVec,yVec,dt);
    MSD{ii} = sqrt(MSDx{ii}.^2 + MSDy{ii}.^2);
    meanLogSlope(ii) = log(MSD{ii}(slopeMax/dt)/MSD{ii}(slopeMin/dt))/log(slopeMax/slopeMin);
end


% Truncate meanLogSlope and xPos, yPos to get rid of startIndex:

xPos = xPos(startIndex+1:lengthVec-startIndex);
yPos = yPos(startIndex+1:lengthVec-startIndex);
meanLogSlope = meanLogSlope(startIndex+1:lengthVec-startIndex);
t = 0:dt:(length(xPos)-1)*dt;