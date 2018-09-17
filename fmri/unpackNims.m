function unpackNims(topFolder)
% cd /Volumes/invPRF/JG180514
% nims output is in a really annoying folder structure. let's fix this
% efficiently
% top folder should be the mrVista folder for this subject/session

if ~exist('topFolder','var');
    topFolder = pwd;
end
% nims folder is in the structure:
% nims/kalanit/project/files/sessionName/indivFolders

cd(topFolder);

% get to the session level of this file structure
cd nims
for x = 1:3
    d = dir;
    cd(d(end).name);
end

sessDir = pwd;

sess = dir; sess = sess([sess.isdir]);
sess = sess(3:end); % cut initial . and .. directories

for x = 1:length(sess)
d = dir([sessDir '/' sess(x).name]);
copyfile([sess(x).name '/' d(end).name],[topFolder '/' sess(x).name '.nii.gz']);
end

cd(topFolder);
rmdir('nims','s');
end

