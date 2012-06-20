function [event, segLength, segState, nSeg, segDir,segDistance,segTime,percentActive] = segFind(meanLogSlope,direction,xPos,yPos,smoothFactor,dt)

%% Define threshold: Active for MSD log slope > threshold etc...
threshold = 1;


%% Creat offset vectors and find when smooth function crosses threshold
x = smooth(meanLogSlope,smoothFactor);
x1 = [x;0];
x2 = [0;x];

event = find((x1<threshold & x2>=threshold)|(x1>threshold & x2<=threshold));
if isempty(event)==0
    if event(length(event)) > length(x)
        event(length(event)) = [];
    end
end    

%%  Add 1 and length(x) to event 
event = [1;event;length(x)];

%% Output number of segments per vesicle and length of each segment 
nSeg = length(event)-1;

segLength = diff(event); % Number of time steps, 

% Notation for segType:
% 1 denotes passive
% 2 denotes undetermined
% 3 denotes active


%% Define transport state for each segment, subject to minimum segment length of 20
% threshold defined above!
for ii = 1:nSeg
    if segLength(ii)>20
        if x(event(ii)+1) < threshold
            segState(ii) = 1;
        else
            segState(ii) = 3;
        end
    else
        segState(ii) = 2;
    end
end

% script filled segType here
% for ii = 1:nSeg
    


%% Determine average direction for each segment: 
for ii = 1:nSeg
    meanDir = mean(direction(event(ii):event(ii+1)));
    if meanDir >= 0.5
        segDir(ii) = 1; % Moving away from cell body
    else
        segDir(ii) = 0; % Moving towards cell body
    end
end

%% Determine segDistance and segTime

for ii=1:nSeg
    segTime(ii) = segLength(ii)*dt; %[sec]
    segDistance(ii) = sqrt((xPos(event(ii+1))-xPos(event(ii)))^2+(yPos(event(ii+1))-yPos(event(ii)))^2); %[m]
end

%% Determine percent time active for particle (intentionally doesn't include indeterminate segments!)
percentActive = sum(segTime(find(segState==3)))/(sum(segTime(find(segState==3)))+sum(segTime(find(segState==1))));



