x = smooth(meanLogSlope{6},30);
x1 = [x;0];
x2 = [0;x];

indexRise = x1>1 & x2 <1;
indexFall = x1<1 & x2 >1;

t = 0:dt:(size(x)-1)*dt;
figure
subplot(2,1,1)
plot(t,x);
hold on

plot(t(indexRise),x(indexRise),'rx')
plot(t(indexFall),x(indexFall),'gx')

subplot(2,1,2)
plot(t(1:length(t)-1),vSmooth{6})