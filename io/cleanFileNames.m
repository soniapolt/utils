function fileNames = cleanFileNames(theDir,fileType)
% returns a list of fileNames, omitting weird apple files

if ~exist('theDir','var') theDir = pwd; end
if ~exist('fileType','var') fileType = ''; end

full = dir([theDir '/*' fileType]);
full = {full.name};
c=1;
% eliminates files starting with ._ - why are these formed?
for n = 1:length(full)
    if ~containsTxt(full{n},'._')
        fileNames{c}=full{n}; c = c+1;
    end
end

