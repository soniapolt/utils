function setupFolders(session)
% runs from utils folder

cd .. % main invPRF folder

mkdir(session);
mkdir([session '/Stimuli/parfiles']);
mkdir([session '/Stimuli/output']);

cd utils
end