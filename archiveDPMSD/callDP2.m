%%%%%%
% Temporary data mgt while writing this script:

clear
clc
cd ..
cd sampleData
load 030112_1_control_pdms_200fps_3_Simple.mat
cd ..
cd 20120420_revised


dt = 1/200;
cNoise = 1;

temp = size(xPos);
nParticles = temp(2);

for ii = 1:nParticles
timeAbs{ii} = frameNum{ii}*dt;
time{ii} = 0:dt:dt*(length(timeAbs{ii})-1);
end


%%%%% Find an interesting particle:
[nPmax, distMax] = maxDistance(xPos,yPos);

%%%% Calculate tolerance for DPsimplify as function of FFT of interesting particle:
[PX, freqX] = positiveFFT(xPos{nPmax},1/dt);
[PY, freqY] = positiveFFT(yPos{nPmax},1/dt);
lengthFFT = length(PX);

dFreq = freqX(2) - freqX(1);
intPX = sum(abs(PX(round(lengthFFT/2):lengthFFT)))*dFreq;
intPY = sum(abs(PY(round(lengthFFT/2):lengthFFT)))*dFreq;
noiseLevel = sqrt(intPX^2+intPY^2);
tol = cNoise*noiseLevel;

for ii = 1:nParticles
    [ps{ii},ix{ii}] = dpsimplify(pData{ii},tol);
end



