function [utilsDir] = spUtils
% returns name of utilsDir

tryDirs = { '/Volumes/projects/sonia/utils',...
            '/share/kalanit/projects/sonia/utils',...
            '/Users/Sonia/matlab/utils'};
        
        found = 0;
        for n = 1:length(tryDirs)
            while ~found
            if isdir(tryDirs{n}) 
                utilsDir = tryDirs{n}; found = 1; end % try in sequential order but go with first found
            end
        end
end


