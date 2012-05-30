%%%% Determine tolerance for input to Douglas Peucker algorithm
function [tol,nPmax] = detTolerance(xPos,yPos,dt)

%%%%% Find an interesting particle:


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
nPmax = iiMax;

%%%% Calculate tolerance for DPsimplify as function of FFT of interesting particle:
[PX, freqX] = positiveFFT(xPos{nPmax},1/dt);
[PY, freqY] = positiveFFT(yPos{nPmax},1/dt);
lengthFFT = length(PX);

dFreq = freqX(2) - freqX(1);
intPX = sum(abs(PX(round(lengthFFT/2):lengthFFT)))*dFreq;
intPY = sum(abs(PY(round(lengthFFT/2):lengthFFT)))*dFreq;
tol = sqrt(intPX^2+intPY^2);
