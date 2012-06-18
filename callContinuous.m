

clear
clc

% Note: this method truncates 'startIndex' points from beginning and end of
% all vectors.

%% Load data
x = pwd;
cd ~/doc/research/projects/vesicleTransport/sampleData
load 1_03min_stretch20_pdms_200fps_extrac.mat
cd(x)

%% Define direction away from cell body, [0,2pi], 0 associated with positive x-direction
theta0 = 0.6266;   %radians

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
%for ii = 1:nParticles
%    p{ii} = [xPos{ii},yPos{ii}];
%end

%% Build particle list:
%buildParticleListManual;  % FUNCTION TO MANUALLY SELECT PARTICLES
%analyze = indexVec;
analyze = [2 6];% 7 18 6 179 15 69 204];
%analyze = [2 4 6 7 8 10 13 15 18 69 86 94 110 195 204 395 397 403 425 475 476 578 626];

%% Declare continuout MSD parameters
maxTau = 260E-3;
startIndex = round(maxTau/2/dt);

slopeMin = 100E-3;
slopeMax = 200E-3;

%% Calculat meanLogSlope
for ii = analyze
    ii
    xPosLong{ii} = xPos{ii};
    yPosLong{ii} = yPos{ii};
    [MSD{ii}, meanLogSlope{ii}, tau{ii}, xPos{ii}, yPos{ii}, t{ii}] = continuousMSD(xPos{ii}, yPos{ii}, maxTau, slopeMin, slopeMax, dt);
end

%% Calculate angle by linear fit of neighborhood
for ii = analyze
    theta{ii} = findAngle(xPosLong{ii},yPosLong{ii},startIndex)
end


%% Smooth meanLogSlope
for ii = analyze
    meanLogSlopeSmooth{ii} = smooth(meanLogSlope{ii},20);
    indexP = meanLogSlopeSmooth{ii}<1.0;
%     plot(xPos{ii}(indexP),yPos{ii}(indexP),'r',xPos{ii}(~indexP),yPos{ii}(~indexP),'g')
%     pause
end
% 
%% Plot things
% for ii = 300:1458
%     loglog(tau{2}{ii},MSD{2}{ii},'b',tau{6}{ii},MSD{6}{ii},'r')
%     axis([0 1 1E-16 1E-14])
%     pause
% end


%% Raw velocity calculation and estimation of runV, stagV
for ii = analyze
    vx{ii} = smooth(diff(xPos{ii})/dt,30);
    vy{ii} = smooth(diff(yPos{ii})/dt,30);
    v{ii} = sqrt(vx{ii}.^2+vy{ii}.^2);
    vSmooth{ii} = v{ii};
end  

%% Determine direction. 1 -> moving away from cell body. 0 -> moving toward cell body for ii = analyze
for ii = analyze
    for jj = 1:length(theta{ii})
        if abs(theta{ii}(jj)-theta0)<pi/4 | abs(theta{ii}(jj)-theta0)>3*pi/4
            direction{ii}(jj) = 1;
        else
            direction{ii}(jj) = 0;
        end
    end
end


%% Find mean run velocity and mean stag velocity for entire trajectory
for ii = analyze
    accumA = 0;
    countA = 0;
    accumP = 0;
    countP = 0;
    lengthVec = length(v{ii});
    for jj = 1:lengthVec %startIndex:length(v{ii}-startIndex)
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


%% Find and run basic processing on individual segments
smoothFactor = 30;  %% Important! 

for ii = analyze
    [event{ii},segLength{ii},segType{ii},nSeg(ii)] = segFind(meanLogSlope{ii},smoothFactor);
end
% Note: event is identical to ix{} in DPsimplify output
% Note: setType = 1 implies passive motion, 2 implies undetermined, and 3
% implies active transport


%% Plot trajectories, color coded by transport state
figure
for ii = analyze
    plotBySeg(xPos{ii}, yPos{ii},event{ii},segType{ii})
    pause
    %plotByDir(xPos{ii},yPos{ii},direction{ii})
    %pause
    clf
end



hist(meanRunV(analyze)./meanStagV(analyze))
pause
close all

