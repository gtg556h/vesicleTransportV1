% plot desired segment ii of particle n
function plotSeg(n,ii,p,ix)

figure
plot(p{n}(ix{n}(ii):ix{n}(ii+1),1),p{n}(ix{n}(ii):ix{n}(ii+1),2))