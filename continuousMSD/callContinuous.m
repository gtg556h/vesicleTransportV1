%%% Put displacement data, locally, into tangential/normal basis
%%% Compare high frequency amplitudes of each

%%% Load data.  'cd ..' is unix for move up a directory. If your data is in
%%% the same directory as all m-files, delete all 'cd' commands and just
%%% run the 'load command'.  Data should already be processed with 'mainPPTprocess' such that
%%% displacement units are in meters.
clear
clc

x = pwd;


cd ~/doc/research/projects/vesicleTransport/analysis/sampleData
load 1_03min_stretch20_pdms_200fps_extrac.mat


addpath ~/Dropbox/code/matlab/vesicleTransport

cd(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Constants:
fps = 200;
dt = 1/fps;
dx = 162E-9;
dy = dx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Put position data in xPos, yPos vectors for each particle
for ii = 1:nParticles
    p{ii} = [xPos{ii},yPos{ii}];
end

%% Build particle list:
%buildParticleList;  % FUNCTION TO MANUALLY SELECT PARTICLES
%analyze = indexVec;
analyze = [2 6];% 7 18 6 179 15 69 204];


%% Calculate MSD, continuous!!!
% Target MSD timescale:200msec => Calculate tau at least to 600msec.  
% (Need to average several values for desired timescale to reduce noise)
% Alternatively, I could just evaluate 200msec around point, then smooth
% afterwards.  Yes, I believe this may be more appropriate. 
maxTau = 1000E-3;
startIndex = maxTau/2/dt;

% Define extrema of timescale range to consider in calculation of
% meanLogSlope: (100msec - 200 msec seems to be physiologically relevant)
slopeMin = 100E-3;
slopeMax = 200E-3;

for ii = analyze
    lengthVec = length(xPos{ii})
    for jj = startIndex + 1:lengthVec - startIndex
        xVec = xPos{ii}(jj-startIndex:jj+startIndex);
        yVec = yPos{ii}(jj-startIndex:jj+startIndex);
        [MSDx{ii}{jj}, MSDy{ii}{jj}, t{ii}{jj}, tau{ii}{jj}] = MSDcalc(xVec,yVec,dt);
        MSD{ii}{jj} = sqrt(MSDx{ii}{jj}.^2 + MSDy{ii}{jj}.^2);
        accum = 0;
        for kk = slopeMin/dt:slopeMax/dt
            accum = accum + log(MSD{ii}{jj}(kk+1)/MSD{ii}{jj}(kk))/log(tau{ii}{jj}(kk+1)/tau{ii}{jj}(kk));
        end
        meanLogSlope{ii}(jj) = accum/((slopeMax/dt+1)-slopeMin/dt);
    end
end

for ii = analyze
    indexP = meanLogSlope{ii}<1.1
    plot(xPos{ii}(indexP),yPos{ii}(indexP),'r',xPos{ii}(~indexP),yPos{ii}(~indexP),'g')
    pause
end
% Adjust to get rid of connecting line between subsequent sections of same
% class:  See:
% http://www.mathworks.com/matlabcentral/answers/1156-conditional-plotting-changing-color-of-line-based-on-value

% Representative plot
% plot(tau{6},smooth(meanLogSlope{6},7))



%% Notes
% First off, regarding MSD criteria, 100-200 msec appears to be the sweet
% spot, NOT my first 50 points. 

% Second off: regarding path segmentation.  Using DP inherently introduces
% irregularitied (see characteristic dip associated with > than 1/3 max
% tau)

% I can either limit myself to analysis < 1/3 max tau (preferably 1/6)

% Alternatively I can restructure such that I calculate the 'state' at each
% point of my data, by determining the MSD centered around a point.  In
% particular, for MSD of tau of 200mSec, and 5 points to average, I need to
% sample .5 sec  to the left, .5 sec to the right.  For 10 points, 1 sec to
% the left, 1 sec to the right.  This requires a whole new code, but it is
% worthwhile to write.