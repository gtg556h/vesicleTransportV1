function [event, segLength, segType, nSeg] = segFind(meanLogSlope,smoothFactor)

x = smooth(meanLogSlope,smoothFactor);
x1 = [x;0];
x2 = [0;x];

% indexRise = x1>1 & x2 <1;
% indexFall = x1<1 & x2 >1;

event = find((x1<1 & x2>=1)|(x1>1 & x2<=1));
if isempty(event)==0
    if event(length(event)) > length(x)
        event(length(event)) = [];
    end
end    
    
event = [1;event;length(x)];

nSeg = length(event)-1;

segLength = diff(event);

% Notation for segType:
% 1 denotes passive
% 2 denotes undetermined
% 3 denotes active

threshold = 1;

for ii = 1:nSeg
    if segLength(ii)>20
        if x(event(ii)+1) < threshold
            segType(ii) = 1;
        else
            segType(ii) = 3;
        end
    else
        segType(ii) = 2;
    end
end




