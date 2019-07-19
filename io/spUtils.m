function [utilsDir] = spUtils
% returns name of utilsDir

tryDirs = { '/Volumes/projects/sonia/utils',...
    '/share/kalanit/projects/sonia/utils',...
    '/Users/kalanit/Experiments/Sonia/utils',...
    '/Users/Sonia/matlab/utils'};
try
utilsDir = tryDirs{find(isfolder(tryDirs),1,'first')};
catch error('Cannot find sp-utils!'); end

end



