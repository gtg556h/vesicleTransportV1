

clear
clc

%% Load data
x = pwd;
cd ~/doc/research/projects/vesicleTransport/analysis/sampleData
load 1_03min_stretch20_pdms_200fps_extrac.mat
cd(x)

%% Add vesicleTransport library to path
addpath ~/git/vesicleTransport

%% Fix default figure position for erdos
set(0,'defaultfigureposition',[330 330 560 420])

%% Constants:
fps = 200;
dt = 1/fps;
dx = 162E-9;
dy = dx;

%% Put position data in xPos, yPos vectors for each particle
for ii = 1:nParticles
    p{ii} = [xPos{ii},yPos{ii}];
end

%% Build particle list:
%buildParticleList;  % FUNCTION TO MANUALLY SELECT PARTICLES
%analyze = indexVec;
analyze = [2 6];% 7 18 6 179 15 69 204];


%% Declare continuout MSD parameters
maxTau = 260E-3;
startIndex = round(maxTau/2/dt);

slopeMin = 100E-3;
slopeMax = 200E-3;

%% Calculat meanLogSlope
for ii = analyze
    [MSD{ii}, meanLogSlope{ii}, tau{ii}] = continuousMSD(xPos{ii}, yPos{ii}, maxTau, slopeMin, slopeMax, dt);
    meanLogSlope{ii} = [meanLogSlope{ii}, zeros(1,startIndex)];
end


%% Smooth meanLogSlope
for ii = analyze
    meanLogSlopeSmooth{ii} = smooth(meanLogSlope{ii},20);
    indexP = meanLogSlopeSmooth{ii}<1.0;
    %plot(xPos{ii}(indexP),yPos{ii}(indexP),'r',xPos{ii}(~indexP),yPos{ii}(~indexP),'g')
    %pause
end

%% Plot things
% for ii = 300:1458
%     loglog(tau{2}{ii},MSD{2}{ii},'b',tau{6}{ii},MSD{6}{ii},'r')
%     axis([0 1 1E-16 1E-14])
%     pause
% end

%%
for ii = analyze
    vx2{ii} = diff(xPos{ii})/dt;
    vy2{ii} = diff(yPos{ii})/dt;
    v2{ii} = sqrt(vx2{ii}.^2+vy2{ii}.^2);
    vSmooth2{ii} = smooth(v2{ii},30);
end

for ii = analyze
    vx{ii} = smooth(diff(xPos{ii})/dt,30);
    vy{ii} = smooth(diff(yPos{ii})/dt,30);
    v{ii} = sqrt(vx{ii}.^2+vy{ii}.^2);
    vSmooth{ii} = v{ii};
end    
%%

%%
for ii = analyze
    accumA = 0;
    countA = 0;
    accumP = 0;
    countP = 0;
    for jj = startIndex:length(v{ii}-startIndex)
        if meanLogSlope{ii}(jj) > 1
            accumA = accumA + vSmooth{ii}(jj);
            countA = countA +1;
        else
            accumP = accumP + vSmooth{ii}(jj);
            countP = countP +1;
        end
    end
    meanRunV(ii) = accumA/countA;
    meanStagV(ii) = accumP/countP;
end

meanRunV
meanStagV
