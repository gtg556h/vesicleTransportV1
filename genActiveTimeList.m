activeTimeList = [];

for ii = analyze
    for jj = 1:nSeg(ii)
        if segType{ii}(jj) == 3
            activeTimeList = [activeTimeList, segLength{ii}(jj)*dt];
        end
    end
end
