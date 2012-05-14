% Script to plot with color based on segment type

function plotBySeg(p,ix,segType)


nSegments = length(ix) - 1;

%figure
hold on
for ii = 1:nSegments
    if segType(ii) == 1
	plot(p(ix(ii):ix(ii+1),1),p(ix(ii):ix(ii+1),2),'r');
    elseif segType(ii) == 2	
        plot(p(ix(ii):ix(ii+1),1),p(ix(ii):ix(ii+1),2),'b');
    elseif segType(ii) == 3
        plot(p(ix(ii):ix(ii+1),1),p(ix(ii):ix(ii+1),2),'g');
    end
end
hold off

