function c = roiColors(roiNames)
% now allow call to more than one color returned

if ~iscell(roiNames) roiNames = {roiNames}; end % if we're giving a single ROI as a string

rColors = {
    [255 30 122]/255    % V1 - pink
    [51 17 187]/255     % V2 - blue
    [255 188 33]/255    % V3 - yellow
    [238 17 0]/255      % hV4 - red
    [255 153 51]/255    % IOG - orange
    [105 208 37]/255    % pFus - green
    [17 170 187]/255    % mFus - light-blue
    [68 34 153]/255     % pSTS - purple
    [195 84 255]/255    % mSTS - ultraviolet
    };

c = [];
allROIs = standardROIs;

for n = 1:length(roiNames)
    found = 0;
    m = cellNum(roiNames{n},allROIs);
    if ~isempty(m) % exact name match
        c = [c; rColors{m}]; found = 1;
    else
        for p = 1:length(allROIs)
            if ~found && containsTxt(roiNames{n},allROIs{p}) || containsTxt(allROIs{p},roiNames{n}) % partial name match
                c = [c; rColors{p}]; found = 1; end
        end
    end
    if ~found % no name match - assign grey
        fprintf('No color match for ROI %s...\n');
        c = [c; [.5 .5 .5]];
    end
end

