%% Script to find smooth angle by linear fit in local region

function [theta] = findAngle(xPosLong,yPosLong,startIndex)

diffVector = diff(xPosLong) + i*diff(yPosLong);

for ii = startIndex+1:length(xPosLong)-startIndex
    theta(ii-startIndex) = angle(diffVector(ii));
    theta(ii-startIndex) = mod(theta(ii-startIndex),2*pi);
end

