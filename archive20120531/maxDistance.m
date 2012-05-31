function [iiMax,distMax] = maxDistance(xPos,yPos)
%%% Script to find the particle that travels the maximum distance, only
%%% considering first and last time points!!!


temp = size(xPos);
nParticles = temp(2);

distMax = 0;
for ii = 1:nParticles
    lengthVec = length(xPos{ii});
    distVec = sqrt((yPos{ii}(lengthVec)-yPos{ii}(1))^2+(xPos{ii}(lengthVec)-xPos{ii}(1))^2);
    if distVec > distMax
        iiMax = ii;
        distMax = distVec;
    end
end


iiMax;
distMax;
%plot(xPos{iiMax},yPos{iiMax})