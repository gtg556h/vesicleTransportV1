% 
function [nDPSegments,segTime,segDist,segV,segType,runV,runTime] = analyzeSeg(ps,ix,dt,cDd,cBd,cDv,cBv,cDt,cBt)

nDPSegments = length(ix) - 1;
runT = 0;
runCount = 0;
runV = 0;

for ii = 1:nDPSegments
    segTime(ii) = dt*(ix(ii+1) - ix(ii));
    segDist(ii) = sqrt((ps(ii+1,1)-ps(ii,1))^2+(ps(ii+1,2)-ps(ii,2))^2);
    segV(ii) = segDist(ii)/segTime(ii);
    if segV(ii) < cBv & segTime(ii) > cBt
        segType(ii) = 1;	%  1 denotes Browninan motion
    elseif segDist(ii) > cDd & segTime(ii)>cDt & segV(ii) > cDv	%
        segType(ii) = 3;	%  3 denotes directed motion
	runT = runT + segTime(ii);
	runCount = runCount + 1;    % To calculate mean run velocity at end
        runV = runV + segV(ii);     % Accumulate velocity, scale to mean after iteration
    else
    segType(ii) = 2;		%  2 denotes undetermined motion
    end
end

runTime = runT/sum(segTime);
runV = runV/runCount;
psCompIndex = 1;

%for ii = 1:nDPSegments
%    if segType(ii) == 3
%	psCompiled
