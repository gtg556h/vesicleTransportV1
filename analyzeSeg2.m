% 
function [nDPSegments,segTime,segDist,segV,segType,runV,runTime,MSDx,MSDy,MSD,tau,meanLogSlope] = analyzeSeg2(xPos,yPos,ps,ix,dt,cDt,cBt)

nDPSegments = length(ix) - 1;
runT = 0;
runCount = 0;
runV = 0;

nPoints = round(cBt/dt);

for ii = 1:nDPSegments
    xVec = xPos(ix(ii)+1:ix(ii+1));
    yVec = yPos(ix(ii)+1:ix(ii+1));
    lengthSeg = ix(ii+1) - ix(ii);
    accum = 0;
    segTime(ii) = dt*(ix(ii+1) - ix(ii));
    segDist(ii) = sqrt((ps(ii+1,1)-ps(ii,1))^2+(ps(ii+1,2)-ps(ii,2))^2);
    segV(ii) = segDist(ii)/segTime(ii);
    if segTime(ii) > cBt
        [MSDx{ii}, MSDy{ii}, t{ii}, tau{ii}] = MSDcalc(xVec,yVec, dt);
        MSD{ii} = sqrt(MSDx{ii}.^2 + MSDy{ii}.^2);
        meanLogSlope(ii) = meanLogSlopeCalc(MSD{ii},tau{ii},nPoints,dt);
        if meanLogSlope(ii) < 1
            segType(ii) = 1;	%  1 denotes Browninan motion
        elseif meanLogSlope(ii) > 1
            segType(ii) = 3;    %  3 denotes directed motion
        else
            segType(ii) = 2;
        end    
    else
        segType(ii) = 2;    %  2 denotes undetermined motion
        meanLogSlope(ii) = NaN;
    end
end

runTime = runT/sum(segTime);
runV = runV/runCount;
psCompIndex = 1;

%for ii = 1:nDPSegments
%    if segType(ii) == 3
%	psCompiled
