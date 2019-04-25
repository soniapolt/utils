function [plotVox] = sortByR2(fits)
% sort prf fit voxels by R2 value
    
    % trim nan fits, which otherwise get sorted as >100
    for c = 1:length(fits) for n = 1:length(fits(c).vox)
            if isnan(fits(c).vox(n).r2) fits(c).vox(n).r2=0; end
        end
    end
    
    sortBy = [fits(1).vox.r2];
    for n = 2:length(fits)
        sortBy = [sortBy; [fits(n).vox.r2]]; end
    sortBy = mean(sortBy);
    [~,plotVox] = sort(sortBy,2,'descend');
end

