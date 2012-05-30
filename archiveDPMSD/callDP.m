%%%% Script to call dpsimplify.m
%%%% Then smooths particle motion by using dpsimplify.m
%%%% Then plots discrete velocity regions using simplified trajectory

%%%% 20120320: Determines tolerance by analyzing fourier decomposition of particle
%%%% motion

%%%% Load data
%%cd sampleData
%%load 030112_1_control_pdms_200fps_3_out.mat
%%cd ..

%%%% 20120322: Determines angle of velocity, rotates x and y to
%%%% tangential/normal basis, compares high frequency motion in these two
%%%% directions

% Constants:
dt = 1/200;
%tolFactor = 40;   % Factor to determine tolerance as function of distMax
cNoise = 1;  % Factor to scale high frequency displacement amplitude when determining tolerance of dpSimp

% Create vector listing number of timesteps for each particle
temp = size(xPos);
nParticles = temp(2);
for ii=1:nParticles
    particleTime(ii) = length(xPos{ii});
end

% Find interesting particle, determined by maximum displacement
% between first and last timepoint:
[nPmax,distMax] = maxDistance(xPos,yPos) ;   %% nP denotes indice of selected particle


% Rearrange data for dpSimplify function:
lengthVec = length(xPos{nPmax});
p = zeros(lengthVec,2);
p(:,1) = xPos{nPmax};
p(:,2) = yPos{nPmax};


% Determine tolerance for dpsimplify as a multiple of amplitude of
% high-frequency spectrum content
% Total amplitude determined by integrating fourier spectrum for 
% second half of available frequency content:
[PX,freqX]=positiveFFT(p(:,1),1/dt);
[PY,freqY]=positiveFFT(p(:,2),1/dt);
lengthFFT = length(PX);

dFreq = freqX(2) - freqX(1);    
intPX = sum(abs(PX(round(lengthFFT/2):lengthFFT)))*dFreq;
intPY = sum(abs(PY(round(lengthFFT/2):lengthFFT)))*dFreq;
noiseLevel = sqrt(intPX^2+intPY^2);
tol = cNoise*noiseLevel;



%%%% Lame way of determining tolerance: 
% Determine tolerance for dpsimplify as a factor of total displacement 
%tol = distMax/tolFactor;

%%%%%%  Run simplifications
% Run dpsimplify
[ps,ix] = dpsimplify(p,tol);

%figure
%plot(ps(:,1),ps(:,2),p(:,1),p(:,2))
%legend('Douglas-Peucker','Raw Data')

% Generate velocity vector vSmooth for dpsimplify data
length2 = length(ix);
for ii = 2:length2
    vSmoothLong(ix(ii-1):ix(ii)) = sqrt((ps(ii,1)-ps(ii-1,1))^2 + (ps(ii,2)-ps(ii-1,2))^2)/((ix(ii)-ix(ii-1))*dt);
    thetaLong(ix(ii-1):ix(ii)) = phase((ps(ii,1)-ps(ii-1,1))+i*(ps(ii,2)-ps(ii-1,2)));
    theta(ii) = phase((ps(ii,1)-ps(ii-1,1))+i*(ps(ii,2)-ps(ii-1,2)));
    vSmooth(ii) = sqrt((ps(ii,1)-ps(ii-1,1))^2 + (ps(ii,2)-ps(ii-1,2))^2)/((ix(ii)-ix(ii-1))*dt);
end
theta = theta(2:length2)';
vSmooth = vSmooth(2:length2)';
% Get rid of occasional outlier where tolerance doesn't wipe out high
% speed random motion:
meanVSmooth = mean(vSmoothLong);
for ii = 1:lengthVec
    if vSmoothLong(ii)>10*meanVSmooth
        vSmoothLong(ii) = vSmoothLong(ii-1);
    end
end

%%% Plot meanVSmooth
%figure
t = [0:dt:(length(vSmoothLong)-1)*dt];
%plot(t,vSmoothLong)

%%%% Convert to normal tangential basis using theta(ii)
