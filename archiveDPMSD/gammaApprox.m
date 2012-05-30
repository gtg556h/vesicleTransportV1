function [G1,G2,tau2,freq2] = gammaApprox(MSD,tau,a,T)
%% Based on Mason article, 2000

kb = 1.381E-23;      % Boltzmann

lengthVec = length(MSD) - 2;

alpha = zeros(1,lengthVec);
absG = zeros(1,lengthVec);
G1 = zeros(1,lengthVec);
G2 = zeros(1,lengthVec);
tau2 = tau(2:lengthVec+1);
freq2 = 1./tau2;
% Note:  I'm not defining alpha at the end points.  I can do this by
% extrapolating, but I don't particularly trust the accuracy here anyways

for kk = 1:lengthVec
    alpha(kk) = .5*log(MSD(kk+2)/MSD(kk+1))/log(tau(kk+2)/tau(kk+1))+.5*log(MSD(kk+1)/MSD(kk))/log(tau(kk+1)/tau(kk));
    % alpha(kk) = log(MSD(kk+2)/MSD(kk))/log(tau(kk+2)/tau(kk));
    denom = pi*a*MSD(kk+1)*gamma(1+alpha(kk));
    absG(kk) = kb*T/denom;
    G1(kk) = absG(kk)*cos(pi*alpha(kk)/2);
    G2(kk) = absG(kk)*sin(pi*alpha(kk)/2);
end

