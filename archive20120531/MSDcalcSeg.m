function [MSDx,MSDy,t,tau] = MSDcalcSeg(n,ii,p,ix,dt)

x = p{n}(ix{n}(ii):ix{n}(ii+1),1);
y = p{n}(ix{n}(ii):ix{n}(ii+1),2);

[MSDx, MSDy, t, tau] = MSDcalc(x, y, dt);