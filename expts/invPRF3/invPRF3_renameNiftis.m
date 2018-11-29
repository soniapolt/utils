function invPRF_renameNiftis

preScans = {'3plane','ASSET','Inplane'};
preFix = 'prf';

s = dir('*.nii.gz');
fileNames = {s.name};

% eliminates files starting with ._ - why are these formed?
if sum((strncmp(fileNames, '._',1)))>0
delete(fileNames{strncmp(fileNames, '._',1)});end

% renames prescans
for n = 1:length(preScans)
s = dir(['*' preScans{n} '*.nii.gz']);
for m = 1:length(s)
   movefile(s(m).name,[preScans{n} '.nii.gz']); 
end
end

% deletes screen_saves
s = dir(['*Screen_Save*.nii.gz']);
if length(s)>0
    delete(s.name);
end

s = dir(['*BOLD_EPI*.nii.gz']);
epis = natsort({s.name}); % sorts according to number prefix

for n = 1:length(epis)
   movefile(epis{n},[preFix num2str(n) '.nii.gz']); 
end
