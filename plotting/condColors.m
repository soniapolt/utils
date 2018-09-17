function c = condColors(condNum,rainbow)
% now allow call to more than one color returned
if ~exist('rainbow','var')
    condColors = {[191 66 244]/255 [0 128 0]/255 [76 94 255]/255 [244 104 65]/255};
else
    condColors = {
        [238 17 0]/255     % red
        [255 153 51]/255     % orange
        [208 195 16]/255   % yellow
        [105 208 37]/255    % green
        [17 170 187]/255  % light-blue
        [51 17 187]/255     % blue
        [68 34 153]/255     % purple
        [220 59 251]/255    % magenta
        };
end

c = [];
for n = 1:length(condNum)
    m=mod(condNum(n),length(condColors));
    if m==0 m = length(condColors); end
    
    c = [c; condColors{m}];
end

end
