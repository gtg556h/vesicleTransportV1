function [MSD, meanLogSlope, tau] = continuousMSD(xPos, yPos, maxTau, slopeMin, slopeMax, dt)

startIndex = round(maxTau/2/dt);
lengthVec = length(xPos);


for ii = startIndex + 1:lengthVec - startIndex
    xVec = xPos(ii-startIndex:ii+startIndex);
    yVec = yPos(ii-startIndex:ii+startIndex);
    [MSDx{ii}, MSDy{ii}, t{ii}, tau{ii}] = MSDcalc(xVec,yVec,dt);
    MSD{ii} = sqrt(MSDx{ii}.^2 + MSDy{ii}.^2);
    meanLogSlope(ii) = log(MSD{ii}(slopeMax/dt)/MSD{ii}(slopeMin/dt))/log(slopeMax/slopeMin);
end