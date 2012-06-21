% plot normalized histogram:
binWidth = dt;
bins = [-15*binWidth:binWidth:15*binWidth];
[n,x]=hist(timeAccum,bins);
bar(x,n./sum(n),1)

% determine normal fit:
[muhat,sigmahat] = normfit(timeAccum)
normX = -5*sigmahat:1E-3:5*sigmahat;
normY = pdf('normal',normX,muhat,sigmahat);
figure
plot(normX,normY)