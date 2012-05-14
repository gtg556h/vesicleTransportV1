function output = meanLogSlopeCalc(MSD,tau,nPoints,dt)

lengthVec = length(MSD);
nPoints = lengthVec;% comment this out to go back to predetermined nPoints
if nPoints*dt>0.5
    nPoints = round(0.5/dt);
end

accum = 0;
for ii = 1:nPoints - 1
    accum = accum + log(MSD(ii+1)/MSD(ii))/log(tau(ii+1)/tau(ii));
end

output = accum/(nPoints-1);