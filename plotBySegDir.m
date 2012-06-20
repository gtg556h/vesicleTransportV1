% Script to plot with color based on segment type

function plotBySegDir(xPos, yPos,ix,segDir)
% Changed from p to xPos, yPos 2012.06.04


nSegments = length(ix) - 1;

%figure
hold on
for ii = 1:nSegments
    if segDir(ii) == 1
	plot(xPos(ix(ii):ix(ii+1)),yPos(ix(ii):ix(ii+1)),'g');
    elseif segDir(ii) == 0	
        plot(xPos(ix(ii):ix(ii+1)),yPos(ix(ii):ix(ii+1)),'r');
    end
    axis equal
end
hold off

