function [utilsDir] = spUtils
% returns name of utilsDir

tryDirs = { '/Volumes/projects/sonia/utils',...
    '/share/kalanit/projects/sonia/utils',...
    '/Users/kalanit/Experiments/Sonia/utils',...
    '/Users/Sonia/matlab/utils'};

found = 0; while ~found
    for n = 1:length(tryDirs)
        if isdir(tryDirs{n})
            utilsDir = tryDirs{n}; found = 1; end
        if n==length(tryDirs) && ~found
            error('Cannot find SPUTILS...'); end
    end % try in sequential order but go with first found
end
end



