function [data] = cvnsqueeze(data)
% function [data] = cvnqueeze(mgzdata)
% saving some typing for loading via cvnloadmgz
data = squeeze(data(:,:,:,1));
end

