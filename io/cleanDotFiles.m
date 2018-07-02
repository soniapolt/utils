%cleanDotFiles


%fileNames = dir('*.nii*');
fileNames = dir;
fileNames = {fileNames.name};

% eliminates files starting with ._ - why are these formed?
delete(fileNames{strncmp(fileNames, '._',2)});

