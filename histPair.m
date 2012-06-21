function histPair(Q,R)

%Q = randn(1000,1);
%R = randn(1000,1)+3;

hist(Q,20)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','w','facealpha',0.75)
hold on;
hist(R,20)
h1 = findobj(gca,'Type','patch');
set(h1,'facealpha',0.75);