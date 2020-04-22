function [plotVox] = pickPlotVox(fits,sortR2,numVox)
% [plotVox] = pickPlotVox(fits,sortR2,numVox)
% replaces typical if sortR2 == 1 process
% sort R2 = select best-fit voxels first
% numVox if R2 = 1: n vox, in R2 order
% numVox if R2 = 1: n vox, random selection

%%%%% are we choosing voxels by their R2 value?
if sortR2 == 1
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
else
    plotVox = 1:length(fits(1).vox);
end

if exist('numVox','var')
    if sortR2 == 1
        plotVox = plotVox(1:numVox);else
        plotVox = datasample(plotVox,numVox,'Replace',false)
    end
end

end

