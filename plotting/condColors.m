function c = condColors(condNum,rainbow)
if ~exist('rainbow','var')
    condColors = {[191 66 244]/255 [0 128 0]/255 [76 94 255]/255 [244 104 65]/255};
else
    condColors = {
        [0/360  1 1]     % red
        [30/360 1 1]     % orange
        [60/360 1 .92]  % yellow
        [105/360 1 .9]   % green
        [180/360 1 .9]  % light-blue
        [240/360 1 .9]    % blue
        [280/360 1 .75]    % purple
        [305/360 1 .82]   % magenta
        [1       1 1]    % red
        };
end
condNum=mod(condNum,length(condColors));
if condNum==0 condNum = length(condColors); end

c = condColors{condNum};
end