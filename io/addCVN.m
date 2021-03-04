function addCVN
% adds necessary libraries for NSFpRF project - cvncode, freesurfer_matlab,
% and nsdcode

if ~exist('raid.m')
    error('Please add sp-utils first!\n');
else
    addpath(genpath([raid 'NSDprf/code/cvncode']));
    addpath(genpath([raid 'NSDprf/code/freesurfer_matlab']));
    addpath(genpath([raid 'NSDprf/code/nsdcode']));
end
end

