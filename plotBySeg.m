% Script to plot with color based on segment type

function plotBySeg(xPos, yPos,ix,segType)
% Changed from p to xPos, yPos 2012.06.04


nSegments = length(ix) - 1;

%figure
hold on
for ii = 1:nSegments
    if segType(ii) == 1
	plot(xPos(ix(ii):ix(ii+1)),yPos(ix(ii):ix(ii+1)),'r');
    elseif segType(ii) == 2	
        plot(xPos(ix(ii):ix(ii+1)),yPos(ix(ii):ix(ii+1)),'b');
    elseif segType(ii) == 3
        plot(xPos(ix(ii):ix(ii+1)),yPos(ix(ii):ix(ii+1)),'g');
    end
    axis equal
end
hold off

