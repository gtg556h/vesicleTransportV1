function [MSDx, MSDy, t, tau] = MSDcalc(x, y, dt)


n = length(x);

t = [0:dt:(n-1)*dt];

tau = [dt:dt:t(n)-t(1)];

MSDx=zeros(n-1,1);
MSDy=zeros(n-1,1);

for ii = 1:n-1
    for jj = 1:ii:n-ii
        MSDx(ii) = MSDx(ii)+((x(ii+jj)-x(jj))^2)/(floor((n-1)/ii);
        MSDy(ii) = MSDy(ii)+((y(ii+jj)-y(jj))^2)/(floor((n-1)/ii);
    end
end

