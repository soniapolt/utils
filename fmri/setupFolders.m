function setupFolders(session,exptDir)
% runs from utils folder

startDir = pwd;
checkDir(exptDir);
cd(exptDir);

mkdir(session);
mkdir([session '/Stimuli/parfiles']);
mkdir([session '/Stimuli/output']);

cd(startDir)
end