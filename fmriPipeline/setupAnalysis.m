% set up analysis after importing scans, prepping for mrVista
clear all; close all;

% RUNS FROM UTILS DIR
proj = 'sonia/localizers';

if containsTxt(pwd,'Volumes')
exptDir = ['/Volumes/projects/' proj];
addpath(genpath('/Volumes/projects/sonia/utils'));
else
exptDir = ['/share/kalanit/biac2/kgs/projects/' proj];
addpath(genpath('/share/kalanit/biac2/kgs/projects/sonia/utils'));
end

exptVersion = 'kidLoc';
exptDir = [exptDir '/' exptVersion '/'];
session = 'MZ190410';
numRuns = 4;

if exist([exptDir session '/Stimuli'])==0
setupFolders(session,exptDir); % do this here if you haven't yet
end

% which parts of set-up do we want to run?
rename = 0;
pars =0;
filtIms =0;
makeAnatLn = 0;
unpack = 1;
renameNifti = 1;
transformNifti = 1;


% first, run setupFolders(session), and transfer the matlab output files
% from the scan computer to Stimuli/output directory

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% rename output files
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rename those files to the standardized runOutput_x
if rename == 1
cd([exptDir session '/Stimuli/output']);
fileNames = dir('*.mat');
fileNames = {fileNames.name};

% eliminates files starting with ._ - why are these formed?
fileNames = {fileNames{~strncmp(fileNames, '._',2)}};
fileNames = natsort(fileNames);



    for k = 1:length(fileNames)
        thisFile= fileNames{k};
        
        % Prepare the output filename.
        outputFile = sprintf('%s_%s.mat', exptVersion,num2str(k));
        
        % Do the copying and renaming all at once.
        copyfile(fullfile(pwd,thisFile), fullfile(pwd,outputFile));
    
        % Print so that we can check correctness
        fprintf('Renamed %s to %s...\n',thisFile,outputFile);
    end
end
%WaitSecs(5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% make parfiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if pars == 1
    writePar(session,exptDir,exptVersion,[1:numRuns]);
    fprintf('Wrote the pars!\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% write out filtered images
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 = binary, 2 = photo, 3 = edge

if filtIms == 1
    for ii = [2 5] %1:2 % default = just binary & photo
        switch exptVersion
            case 'invPRF3'
        invPRF3_writeFiltIms(ii,session,exptDir,exptVersion,[1:numRuns])
            case 'fixPRF'
                fixPRF_writeFiltIms(ii,session,dirOf(exptDir,1),[1:numRuns])
            case 'compPRF'
                compPRF_writeFiltIms(ii,session,dirOf(exptDir,1),[1:numRuns])
        end
    end
    fprintf('Wrote mean images from the scanner stimuli!!\n');
end
cd(exptDir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% unpack nims data structure 
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% nims folders are unzipped in your subject
% directory already

if unpack == 1
   % unpackNims([exptDir session]);
   % fprintf('Unpacked Nims folders!\n');
   unpackFlyw([exptDir session]);
   fprintf('Unpacked Flywheel folders!\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% rename niftis
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if renameNifti == 1
    cd([exptDir '/' session]);
    renameNiftis('l');
    fprintf('Renamed your niftis!\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% transform niftis
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if transformNifti == 1
    cd(exptDir);
    transformerDir(session);
    fprintf('Succesfully transformed niftis!\n');
    cd(session);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% makeAnatomyLink
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if makeAnatLn == 1
   cd([exptDir session]);
   makeAnatLink(session(1:2));
end

cd([dirOf(exptDir,2) 'sonia/utils/fmriPipeline']);
