%clear
%clc

%cd sampleData
%load 030112_1_control_pdms_200fps_3_out.mat
%cd ..

temp = size(xPos);
nParticles = temp(2);
indexVec = []

for ii = 1:nParticles
    lengthT = sqrt((xPos{ii}(length(xPos{ii}))-xPos{ii}(1))^2+(yPos{ii}(length(yPos{ii}))-yPos{ii}(1))^2);
    if lengthT>3E-7
	indexVec = [indexVec, ii];
    end
end

