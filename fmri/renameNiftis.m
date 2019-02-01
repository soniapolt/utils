function renameNiftis(preFix,preScans)
if ~exist('preScans','var') || preScans == [];
    preScans = {'3plane','ASSET','Inplane'};
end

%preFix = 'prf';

s = dir('*.nii.gz');
fileNames = {s.name};

% eliminates files starting with ._ - why are these formed?
if sum((strncmp(fileNames, '._',1)))>0
    delete(fileNames{strncmp(fileNames, '._',1)});end

% renames prescans
for n = 1:length(preScans)
    s = dir(['*' preScans{n} '*.nii.gz']);
    
    movefile(s(1).name,[preScans{n} '.nii.gz']);
    fprintf('Renamed %s to %s...\n',s(1).name,[preScans{n} '.nii.gz']);
    
    for m = 2:length(s)
        movefile(s(m).name,[preScans{n} '_' num2str(m) '.nii.gz']);
        fprintf('Renamed %s to %s...\n',s(m).name,[preScans{n} '_' num2str(m) '.nii.gz']);
    end
end

% deletes screen_saves
s = dir(['*Screen_Save*.nii.gz']);
if length(s)>0
    delete(s.name);
end

s = dir(['*BOLD*.nii.gz']);
epis = natsort({s.name}); % sorts according to number prefix

for n = 1:length(epis)
    movefile(epis{n},[preFix num2str(n) '.nii.gz']);
    fprintf('Renamed %s to %s...\n',epis{n},[preFix num2str(n) '.nii.gz']);
end
