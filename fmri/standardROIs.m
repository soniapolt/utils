function [ROIs] = standardROIs(which)
% choose all or some of our most-used ROIs (to save time typing)
ROIset = {'V1' 'V2' 'V3' 'hV4' 'IOG_faces' 'pFus_faces' 'mFus_faces' 'pSTS_faces'};% 'mSTS_faces'};

if ~exist('which','var')
    n = 1:length(ROIset);
elseif containsTxt(which,'face+')
    n = 4:9;
elseif containsTxt(which,'face-')
    n = 5:7;
elseif containsTxt(which,'face')
    n = 5:8;
elseif containsTxt(which,'EVC')
    n = 1:4;
else n = which;
end

ROIs = {ROIset{n}};

end

