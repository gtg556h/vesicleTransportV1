% Script to pull data from polyParticleTracker
% Brian Williams
% 2012.02.21

%%%%%%%%%%%% File management
%data=dataPPT;     % Rename PPT output to variable name 'data'

%%%%%%%%%%%% Declare Constants

data = dataR5;

fps = 200;  % framerate
dt = 1/fps; % timestep

%dt = .02;
%fps = 1/dt

dx = 162E-9;    % Pixel size, set to unity if PPT outputs dimensioned positions
dy = dx;

%%%%%%%%%%%% Number of particles tracked
temp=size(data.tr);
nParticles = temp(2);     % This is the number of particles

%%%%%%%%%%%% Put data into cell arrays based on data type. Index of cell
%%%%%%%%%%%% array indicated particle number

for ii = 1:nParticles
    pData{ii} = data.tr{ii};
    xPos{ii} = pData{ii}(:,1);      %%% x coordinate of particle in pixels
    yPos{ii} = pData{ii}(:,2);      %%% y coordinate of particle in pixels
    
  %  frameNum{ii} = pData{ii}(:,3);  %%% frame number
  %  particleNum{ii} = pData{ii}(:,4);   %%% particle number (set by PPT)
  %  radius{ii} = pData{ii}(:,5);    %%% radius of particle in pixels
 %   jRogers{ii} = pData{ii}(:,6);   %%% See PPT literature
    %eccentricity{ii} = pData{ii}(:,7);  %%% eccentricity.  1 for circle
   % rotation{ii} = pData{ii}(:,8);      %%% Angle of particle for ellipsoid
  %  brightness{ii} = pData{ii}(:,9);    
 %   skewness{ii} = pData{ii}(:,10);
end

%%%%%%%%%%%% Scale xPosition by pixel size:
for ii = 1:nParticles
    xPos{ii} = xPos{ii}*dx;     %%% x position in meters
    yPos{ii} = yPos{ii}*dy;     %%% y position in meters
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate other parameters of interest
%for ii = 1:nParticles
%    zPos{ii} = 1.*radius{ii};   %%% Kind of.  Not really though.  Doesn't distinguish between positive/negative, and is not the proper scaling function
    %%% Put MSD conversion here
%    [MSD{ii},tau{ii}] = MSDcalc(xPos{ii},yPos{ii},dt);
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate plots

%for ii = 1:nParticles
%    figure
%    plot3(xPos{ii},yPos{ii},zPos{ii})
%end
