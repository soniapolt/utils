function unpackFlyw(topFolder)
% cd /Volumes/invPRF/JG180514
% nims output is in a really annoying folder structure. let's fix this
% efficiently
% top folder should be the mrVista folder for this subject/session
% 10/18 edit to be compatible with flywheel's equally annoying folder
% output

if ~exist('topFolder','var');
    topFolder = pwd;
end
% nims folder is in the structure:
% kalanit/sonia/subj/sessionName/indivFolders

cd(topFolder);

% get to the session level of this file structure
cd kalanit
for x = 1:3
    d = dir;
    cd(d(end).name);
end

sessDir = pwd;

sess = dir; sess = sess([sess.isdir]);
sess = sess(3:end); % cut initial . and .. directories

for x = 1:length(sess)
d = dir([sessDir '/' sess(x).name]);
outName = [sess(x).name '.nii.gz'];
% in flywheel, spaces are not automatically udnerscored as they were in
% nims. we'll do that here
outName = strrep(outName,' ','_');
copyfile([sess(x).name '/' d(end).name],[topFolder '/' outName]);
end

cd(topFolder);
rmdir('kalanit','s');
end

