%%% Put displacement data, locally, into tangential/normal basis
%%% Compare high frequency amplitudes of each

%%% Load data.  'cd ..' is unix for move up a directory. If your data is in
%%% the same directory as all m-files, delete all 'cd' commands and just
%%% run the 'load command'.  Data should already be processed with 'mainPPTprocess' such that
%%% displacement units are in meters.
clear
clc
cd ..
cd sampleData
load 030112_1_control_pdms_200fps_3_Simple.mat
cd ..
cd 20120420_revised

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Put position data in xPos, yPos vectors for each particle
for ii = 1:nParticles
    p{ii} = [xPos{ii},yPos{ii}];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine tolerance for use in DPSimplify.  This uses the fourier method.
% cNoise scales the output. 1 seems to work pretty well.
cNoise = 1;
[tol,nPmax] = detTolerance(xPos, yPos ,dt);
tol = cNoise*tol;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Set vector of particles to analyze:  Do this manually by explicitly
%%%% defining a vector of indices associated with the desired particles, or
%%%% run 'buildParticleList' to view all paticles and select which ones to
%%%% analyze

buildParticleList;
analyze = indexVec
%analyze = [nPmax,145,199,242];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Run douglas peucker algorithm.  ps provides coordinates of endpoints.  ix
%%%% provides the associated indices associated with endpoints
for ii = analyze
    [ps{ii},ix{ii}] = dpsimplify(p{ii},tol);   % p in [m], tol is tolerance defined above
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Establish segment length thresholds to differentiate between directe
%%%% motion and brownian motion: Depending on current state of the code,
%%%% many of these are likely not being used.

cDd = 2*tol;   % Directed motion segment distance threshold [m]
cBd = 1.5*tol;   % Brownian motion segment distance threshold [m]
cDv = 1E-7;    % Directed motion segment velocity threshold [m]
cBv = 1E-7;   % Brownian motion segment velocity [m]
cDt = 20*dt; % Directed motion segment time threshold [m]
cBt = 50*dt; % Brownian motion segment time threshold [m]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Actually analyze particles.  This is the core of the analysis.
for ii = analyze
    %[nDPSegments(ii),segTime{ii},segDist{ii},segV{ii},segType{ii},runV(ii),runTime(ii)] = analyzeSeg(ps{ii},ix{ii},dt,cDd,cBd,cDv,cBv,cDt,cBt);
    [nDPSegments(ii),segTime{ii},segDist{ii},segV{ii},segType{ii},runV{ii},runTime(ii),MSDx{ii},MSDy{ii},MSD{ii},tau{ii},meanLogSlope{ii}] = analyzeSeg2(xPos{ii},yPos{ii},ps{ii},ix{ii},dt,cDt,cBt);
end


%%%% Plot segments colored by segment type (red -> brownian, blue -> undetermined, green -> directed motion
figure
for ii = analyze
   clf
   plotBySeg(p{ii},ix{ii},segType{ii})
   legend(num2str(ii))
   pause
end


%%%%% Post analysis computation: determine the meanLogSlope for segments
%%%%% considered active transport for all particles in analysis:
%%%%% MODIFY THIS TO RUN ON ALL PARTICLES!!!!!
accumCount = 0;
accumMLS = 0;
for ii=75
    for jj = 1:length(meanLogSlope{ii})
        if segType{ii}(jj) == 3
            accumMLS = accumMLS + meanLogSlope{ii}(jj);
            accumCount = accumCount + 1;
        end
    end
end
meanMLS  = accumMLS/accumCount

