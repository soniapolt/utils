function makeAnatLink(subj)
% makes a link to the 3D anatomy, given the subject initials
try name = anatName(subj);
catch
    warning('Add this subject to anatName.m, please!');
    name = input('Anatomy Folder Name? ','s');
end
anat = fullfile('/share','kalanit','biac2','kgs','anatomy','vistaVol',name);
lnDir = fullfile(pwd,'3DAnatomy');
fprintf('Making 3DAnatomy of %s in %s...\n',anat,lnDir);
system(['ln -s ' anat ' ' lnDir]);
end