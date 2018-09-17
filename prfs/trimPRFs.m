function [trim] = trimPRFs(fitParams,betas,ppd,res)
%%% trims pRFs in a consistent way
% limits param values to something reasonable
% requires at least one positive beta for each condition (voxel responds
% positively to at least one of the conditions probed)
%
%
% sample inputs:
% fitParams = [69.1370   68.2571    3.0048    1.0180    0.5000   -0.1921];
% ppd = 30; res = 330;

% the parameters of the CSS model are [R C S G N] where
%   R is the row index of the center of the 2D Gaussian
%   C is the column index of the center of the 2D Gaussian
%   S is the standard deviation of the 2D Gaussian
%   G is a gain parameter
%   N is the exponent of the power-law nonlinearity
%   B is the baseline shift

minEccen = 0.125;               % minimum eccentricity (usually corresponds to fixation dot)
minSize = 0.25;                 % in deg, size = [2xSD/sqrt(N)]
maxSize = res/ppd-.25;            % in deg
trimEdge = .25*ppd;              % edge of stimulus, in pix
trimSD= res-.25*ppd;             % trim whole-field SD estimates (in addition to size)
maxShift = 5;                   % absolute value of max shift

size = (2*fitParams(3)/ppd)/sqrt(fitParams(5)); % in deg
XYdeg = (fliplr(fitParams(1:2))-res/2)/ppd; % in deg
eccen = sqrt(XYdeg(1)^2+XYdeg(2)^2); % in deg
                
if      eccen < minEccen  ...
        || size < minSize ...
        || size > maxSize ...
        || fitParams(3) > trimSD ...
        || fitParams(1) < trimEdge ...
        || fitParams(1) > res-trimEdge ...
        || fitParams(2) < trimEdge ...
        || fitParams(2) > res-trimEdge ...
        || (length(fitParams)>5) && abs(fitParams(6))>maxShift ...
        || isempty(find(betas>0)) ...
    trim = 1;
else
trim = 0; end

end

