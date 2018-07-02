function invPRF3_renameNiftis

preScans = {'3plane','asset','inplane'};
preFix = 'prf';

s = dir('*.nii.gz');
fileNames = {s.name};

% eliminates files starting with ._ - why are these formed?
if sum((strncmp(fileNames, '._',1)))>0
delete(fileNames{strncmp(fileNames, '._',1)});end

s = dir('*.nii.gz');

for n = 1:length(preScans)
  movefile(s(n).name,[preScans{n} '.nii.gz']);
end

numRuns = length(s)-length(preScans);

for n = 1:numRuns
   movefile(s(n+length(preScans)).name,[preFix '_' num2str(n) '.nii.gz'] )
end