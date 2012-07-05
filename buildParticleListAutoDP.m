function [indexVec,meanSegLength] = buildParticleListAutoDP(tol,dt,xPos,yPos)


temp = size(xPos);
nParticles = temp(2);
indexVec = [];

for ii = 1:nParticles
    t = 0:dt:(length(xPos{ii})-1)*dt;
    %%%%%%%%%%%% FIX SCALING FACTOR ABOVE!!!!!!
    [ps,ix] = dpsimplify([xPos{ii},yPos{ii},t'],tol);
    nSegments = length(ix)-1;
    lengthT = 0;
    for jj = 1:nSegments
        lengthT = lengthT+sqrt((ps(jj+1,1)-ps(jj,1))^2+(ps(jj+1,2)-ps(jj,2))^2);
    end
    if lengthT>1E-6
	indexVec = [indexVec, ii];
    end
    meanSegLength(ii) = mean(diff(ix));
end

