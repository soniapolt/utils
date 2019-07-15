function [samples, startTime] = ascSampleRead(sampleFile)
% asc2rawMat_sample converts asc files to a raw data variable that can be saved as
% a .mat file. modified from AR's asc2rawMat_sample.m
%
%   [raw, stime] = asc2rawMat_sample( ascFile, pxlScrnDim, mmScrnDim, ...
%                                     scrnDstnce )
%
%       ascFile - (string) filepath to asc file containing sample data
%
%       eyeInit - data file from current initialization of eyetracker,
%       which has distance & screen measures
%
%       output sample - 4 dimensional data matrix of doubles. raw(:,1) gives time, 
%             raw(:,2) gives x coodinate, raw(:,3) gives y coordinate
%
%       startTime - first timepoint listed in ascFile. no longer used for
%       time conversion
%


% open asc file
fid = fopen(sampleFile);

% read data in asc file and organizes it into a 5 column cell array of
% strings called raw. The asc file stores 5 dimensions of data and each
% dimension is separated out into this cell array.
samples = textscan(fid, '%s %s %s %s %s');

% raw{1} stores time, raw{2} stores x coordinate, and raw{3} stores y
% coordinate. We won't use raw{4} or raw{5}, so they get deleted here.
samples(:,4:5) = [];

% Reorganize raw into a matrix of doubles
samples = horzcat(samples{:});
samples = str2double(samples);

% Return stime
startTime = samples(1,1);

% Close asc file
fclose(fid);

end

