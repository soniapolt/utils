function dirName = dirOf(fileName,dirsBack)
% returns the name of a directory in which a given file lives.
% if specified, you can go back up X directories

if ~exist('dirsBack','var')
dirsBack = 0; end

ind = strfind(fileName,'/');
dirName = fileName(1:ind(end-dirsBack));

end

