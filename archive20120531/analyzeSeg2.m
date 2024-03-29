% ADD RUNTIME, RUNV, ETC... CALCULATIONS!!!!
function [nDPSegments,segTime,segDist,segV,segType,runV,runTime,MSDx,MSDy,MSD,tau,meanLogSlope] = analyzeSeg2(xPos,yPos,ps,ix,dt,cDt,cBt)
%%% This code analyzes 1 single particle


nDPSegments = length(ix) - 1;  % Number of segments from dp simplify
runT = 0;   % Initialize accumulation variable
runCount = 0;  % Initialize accumulation variable
runV = 0;   % Initialize accumulation variable
%MSDx{1} = 0;
%MSDy{1} = 0;
%MSD{1} = 0;
nPoints = round(cBt/dt);

for ii = 1:nDPSegments
    xVec = xPos(ix(ii)+1:ix(ii+1));  % raw x-position for single DP segment
    yVec = yPos(ix(ii)+1:ix(ii+1));  % raw y-poistion for single DP segment
    lengthSeg = ix(ii+1) - ix(ii);   % Length of current DP segment,timesteps
    accum = 0; % Initialize accumulation variable
    segTime(ii) = dt*(ix(ii+1) - ix(ii));  % duration time for current DP segment
    segDist(ii) = sqrt((ps(ii+1,1)-ps(ii,1))^2+(ps(ii+1,2)-ps(ii,2))^2); % magnitude of displacement for current DP segment
    segV(ii) = segDist(ii)/segTime(ii);  % Smoothed velocity for current segment (first and last points only!!!)
    if segTime(ii) > cBt   %%% Threshold: following analysis only applied to segments with a minimum duration cBt!!!
        [MSDx{ii}, MSDy{ii}, t{ii}, tau{ii}] = MSDcalc(xVec,yVec, dt);  % MSD values associated with timescale tau.  MSD units [m^2]
        MSD{ii} = sqrt(MSDx{ii}.^2 + MSDy{ii}.^2); % units [m^2]
        meanLogSlope(ii) = meanLogSlopeCalc(MSD{ii},tau{ii},nPoints,dt); % Calculates the averaged logarithmic slope for the MSD generated for current DP segment
        if meanLogSlope(ii) < 1
            segType(ii) = 1;	%  1 denotes Browninan motion
        elseif meanLogSlope(ii) > 1.1
            segType(ii) = 3;    %  3 denotes directed motion
	    runT = runT + segTime(ii);
	    runCount = runCount + 1;
	    runV = runV + segV(ii);
        else
            segType(ii) = 2; % 2 denotes undetermined motion type
        end    
    else
        segType(ii) = 2;    %  2 denotes undetermined motion
        meanLogSlope(ii) = NaN;
    end
end

runTime = runT/sum(segTime);  % generante runTime (unitless ratio) from accumulation variable
runV = runV/runCount; 

if exist('MSDx')==0
	MSDx{1} = 0;
	MSDy{1} = 0;
	MSD{1} = 0;
	tau{1} = 0;
end

