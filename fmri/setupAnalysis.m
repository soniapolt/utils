% set up analysis after importing scans, prepping for mrVista
% RUNS FROM UTILS DIR
exptDir = '/sni-storage/kalanit/biac2/kgs/projects/invPRF/';
%exptDir = '/Volumes/invPRF/';
%addpath(genpath('/Volumes/invPRF/utils'));
addpath(genpath([exptDir 'utils']));

session = 'SP180626';
numRuns = 8;
%setupFolders(session); % do this here if you haven't yet


% which parts of set-up do we want to run?
rename =0;
pars = 0;
transformNifti = 1;
filtIms = 0;

% first, run setupFolders(session), and transfer the matlab output files
% from the scan computer to Stimuli/output directory

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% rename output files
%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd([exptDir session '/Stimuli/output']);
fileNames = dir('*.mat');
fileNames = {fileNames.name};

% eliminates files starting with ._ - why are these formed?
fileNames = {fileNames{~strncmp(fileNames, '._',2)}};

% deduces the experiment name from the output
exptName = fileNames{1};
idcs   = strfind(exptName,'_');
exptName = exptName(1:idcs(1)-1);

% rename those files to the standardized runOutput_x
if rename == 1
    for k = 1:length(fileNames)
        thisFile= fileNames{k};
        
        % deduces the experiment name from the output
        idcs   = strfind(thisFile,'_');
        exptName = thisFile(1:idcs(1)-1);
        runNum = thisFile(idcs(3)-1);
        
        % Prepare the output filename.
        outputFile = sprintf('%s_%s.mat', exptName,runNum);
        
        
        % Do the copying and renaming all at once.
        copyfile(fullfile(pwd,thisFile), fullfile(pwd,outputFile));
    end
    fprintf('Renamed the output files!\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% make parfiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if pars == 1
    writePar(session,exptDir,exptName,[1:numRuns]);
    fprintf('Wrote the pars!\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% transform niftis
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if transformNifti == 1
    cd(exptDir);
    transformerDir(session);
    fprintf('Succesfully transformed niftis!\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% write out filtered images
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 = binary, 2 = photo, 3 = edge

if filtIms == 1
    for ii = 1:3
        writeFiltIms(ii,session,exptDir,exptName,[1:numRuns])
    end
    fprintf('Wrote mean images from the scanner stimuli!!\n');
end
cd(exptDir);
