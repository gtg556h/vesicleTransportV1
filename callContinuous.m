%$%%%%% SCRIPT FILLED SEGTYPE IN segFind.m

clear
clc

% Note: this method truncates 'startIndex' points from beginning and end of
% all vectors.

% Set tolerance for Douglas Peucker fits (used in particle list generation
% and other analysis
tol = 65E-9;
% orginally 65E-9

%%% Load data
x = pwd;
cd ~/doc/research/projects/vesicleTransport/sampleData
load 1_03min_stretch20_pdms_200fps_extrac.mat
cd(x)

%%% Define direction away from cell body, [0,2pi], 0 associated with positive x-direction
theta0 = 0;   %radians

%%% Add vesicleTransport library to path
addpath ~/git/vesicleTransport

%%% Fix default figure position for erdos
%set(0,'defaultfigureposition',[330 330 560 420])

%%% Constants:
fps = 200;
dt = 1/fps;
dx = 162E-9;
dy = dx;

%%% Put position data in xPos, yPos vectors for each particle
%for ii = 1:nParticles
%    p{ii} = [xPos{ii},yPos{ii}];
%end

%% Build particle list:
%buildParticleListManual;  % FUNCTION TO MANUALLY SELECT PARTICLES
%analyze = indexVec;
%[analyze,meanSegLength] = buildParticleListAutoDP(tol,dt,xPos,yPos);
%analyze
%pause

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





% 
%% Plot things (MSD video of sorts)
% for ii = 300:1458
%     loglog(tau{2}{ii},MSD{2}{ii},'b',tau{6}{ii},MSD{6}{ii},'r')
%     axis([0 1 1E-16 1E-14])
%     pause
% end


%% Raw velocity calculation: Note: smooth vx, vy to get rid of high frequency component
for ii = analyze
    xPosLongSmooth{ii} = smooth(xPosLong{ii},25);
    yPosLongSmooth{ii} = smooth(yPosLong{ii},25);
   
    for jj = 1:length(xPos{ii})
        vx{ii}(jj) = (xPosLongSmooth{ii}(jj+startIndex+1) - xPosLongSmooth{ii}(jj+startIndex-1))/(2*dt);
        vy{ii}(jj) = (yPosLongSmooth{ii}(jj+startIndex+1) - yPosLongSmooth{ii}(jj+startIndex-1))/(2*dt);
    end    
    v{ii} = sqrt(vx{ii}.^2+vy{ii}.^2);
    vSmooth{ii} = v{ii};

end  

%% Calculate angle by linear fit of neighborhood
for ii = analyze
    theta{ii} = findAngle(vx{ii},vy{ii});
end


%% Calculate angle and velocity by 3D Douglas Peucker fit:


for ii = analyze
    [ps{ii},ix{ii}] = dpsimplify([xPos{ii},yPos{ii},(t{ii}')/1E4],tol);
    nDPSeg(ii) = length(ix{ii})-1;
    for jj = 1:nDPSeg(ii)
        vDPSegX = (ps{ii}(jj+1,1) - ps{ii}(jj,1))/(ix{ii}(jj+1)-ix{ii}(jj))/dt;
        vDPSegY = (ps{ii}(jj+1,2) - ps{ii}(jj,2))/(ix{ii}(jj+1)-ix{ii}(jj))/dt;
        vDPSeg{ii}(jj) = sqrt(vDPSegX^2 + vDPSegY^2);
        vDP{ii}(ix{ii}(jj):ix{ii}(jj+1)-1) = vDPSeg{ii}(jj);
        thetaDP{ii}(ix{ii}(jj):ix{ii}(jj+1)-1) = findAngle(vDPSegX,vDPSegY);
    end
    vDP{ii}(length(vDP{ii})+1) = vDP{ii}(length(vDP{ii}));
    thetaDP{ii}(length(thetaDP{ii}+1)) = thetaDP{ii}(length(thetaDP{ii}));
    DPSegLength{ii} = diff(ix{ii});
    
    for jj = 1:nDPSeg(ii)
        if DPSegLength{ii}(jj)<20
            vDP{ii}(ix{ii}(jj):ix{ii}(jj+1)-1) = vSmooth{ii}(ix{ii}(jj):ix{ii}(jj+1)-1);
        end
    end
end

figure
hist(vDP{analyze(1)},20)
hold on
hist(-vSmooth{analyze(1)},20)
pause
close all

figure
subplot(1,2,1)
rose(theta{analyze(1)})
legend('Original theta')
subplot(1,2,2)
rose(thetaDP{analyze(1)})
legend('DP theta')
pause
close all

clear vDPSegX vDPSegY



%% Determine direction. 1 -> moving away from cell body. 0 -> moving toward cell body for ii = analyze
for ii = analyze
    for jj = 1:length(theta{ii})
        if abs(theta{ii}(jj)-theta0)<pi/2 | abs(theta{ii}(jj)-theta0)>3*pi/2
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
    lengthVec = length(vSmooth{ii});
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
    meanLogSlopeSmooth{ii} = smooth(meanLogSlope{ii},smoothFactor);
    [event{ii},segLength{ii},segState{ii},state{ii},nSeg(ii),segDir{ii},segDistance{ii},segTime{ii},percentActive(ii)] = segFind(meanLogSlope{ii},direction{ii},xPos{ii},yPos{ii},smoothFactor,dt);
end
% Note: event is identical to ix{} in DPsimplify output
% Note: setType = 1 implies passive motion, 2 implies undetermined, and 3
% implies active transport


%% Use DP information to determin run lengths of events determined by running MSD
% To accomplish, simply integrate the DP velocity over the time points
% associated with a single event:
for ii = analyze
    for jj = 1:nSeg(ii)
        DPRunDistance{ii}(jj) = sum(vDP{ii}(event{ii}(jj):event{ii}(jj+1)-1))*dt;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Start plots

%% Plot trajectories, color coded by transport state
figure
for ii = analyze
    plotBySeg(xPos{ii}, yPos{ii},event{ii},segState{ii})
    title('Plot by segment transport state')
    pause
    %plotByDir(xPos{ii},yPos{ii},direction{ii})
    %pause
    clf
end

%% Plot by mean segment direction
% for ii = analyze
%     plotBySegDir(xPos{ii},yPos{ii},event{ii},segDir{ii})
%     title('Plot by segment direction, green away from body')
%     pause
%     clf
% end

% 
% hist(meanRunV(analyze)./meanStagV(analyze))
% pause

%% Plot histogram of distance travelled in active segments
% for ii = analyze
%     hist(segDistance{ii}(find(segState{ii}==3)))
%     pause
% end
clf
%% Plot 'bimodal' histogram of active velocities, one for direction=1, other for direction=0:
% for ii = analyze
%     hist(vSmooth{ii}(find(state{ii}==3 & direction{ii}==1)))
%     hold on
%     hist(-vSmooth{ii}(find(state{ii}==3 & direction{ii}==0)))
%     pause
% end

% for ii = analyze
%     Q = vSmooth{ii}(find(state{ii}==3 & direction{ii}==1));
%     R = vSmooth{ii}(find(state{ii}==3 & direction{ii}==0));
%     histPair(Q,R)
%     pause
%     clf
% end

close all
%% Summary of variables:
% 
% xPos: x-position of particle [m]

% yPos: y-position of particle [m]

% dt: video timestep [sec]

% dx/dy: pixel size [m]

% analyze: vector of indices for particles to be analyzed

% maxTau: max timescale to calculate MSD.  Determines width of window
% sampled around each point, and consequentially the number of time points
% that are discarded at the beginning of xPos and yPos

% xPosLong: After discarding maxTau/dt/2 at beginning of xPos and yPos,
% xPosLong contains the entire original position vector, in case needed

% startIndex

% MSD: Mean square displacement

% meanLogSlope: slope of linear fit of loglog for MSD

% tau: timescale, abscissa of MSD

% slopeMin: minimum timescale in range of MSD used to calculate
% meanLogSlope

% slopeMax: max timescale tau in range of MSD used to calculate
% meanLogSlope

% theta: angle of current velocity, [0,2pi]

% vSmooth: Smooth magnitude of velocity.  Critical to smooth vx, vy prior
% to computing vSmooth to get rid of high velocity, high frequency,
% brownian component

% direction: equals one if vesicle is travelling away from cell body, zero
% if vesicle is travelling towards cell body

% meanRunV: average of smooth velocity for a vesicle for all timepoints
% that state is equal to 3 (active)

% meanStagV: average of smooth velocity for a vesicle for all timepoints
% that state is equal to 1 (passive)

% event: vector of indices associated with the points that meanLogSlope
% crosses the threshold.  Thus, these points correspond with a change in
% variable 'state'.  All indices between a pair of events make up a
% segment.

% segLength:  vector (not physical) length of each segment

% nSeg: Number of segments identified for a vesicle.

% segState: state (1 for passive, 2 for undetermined, 3 for active) for a
% segment.  vector is nSegments long

% state: filled state vector (length = length(xPos) with same content as
% segState.

% segDir:

% segDistance

% segTime

% percentActive

