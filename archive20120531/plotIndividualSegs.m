function plotIndividualSegs(particleNumber,p,ix,segType,meanLogSlope)


nSegments = length(ix) - 1;

%figure

for ii = 1:nSegments
    plot(p(:,1),p(:,2),'k')
    hold on
    if segType(ii) == 1
	plot(p(ix(ii):ix(ii+1),1),p(ix(ii):ix(ii+1),2),'r');
    elseif segType(ii) == 2	
        plot(p(ix(ii):ix(ii+1),1),p(ix(ii):ix(ii+1),2),'b');
    elseif segType(ii) == 3
        plot(p(ix(ii):ix(ii+1),1),p(ix(ii):ix(ii+1),2),'g');
    end
    legend(strcat('P',num2str(particleNumber),'S ',num2str(ii), 'MSD ',num2str(meanLogSlope(ii))))
    hold off
    pause
end
