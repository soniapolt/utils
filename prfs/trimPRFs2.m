function [trim] = trimPRFs2(vox,ppd,res)
%function [trim] = trimPRFs2(vox,ppd,res)

%%% trims pRFs in a consistent way
% limits param values to something reasonable
% requires at least one positive beta for each condition (voxel responds
% positively to at least one of the conditions probed)
% now works with readPRFs output, not just raw params (makes it more
% flexible with newer models). vox = voxstruct with calculated eccent,
% size, expN, etc
%
% sample inputs:
% fitParams = [69.1370   68.2571    3.0048    1.0180    0.5000   -0.1921];
% ppd = 30; res = 330;

minEccen = 0.125;               % minimum eccentricity (usually corresponds to fixation dot)
minSize = 0.1;                  % in deg, size = [SD/sqrt(N)]
maxSize = res/ppd-.1;           % in deg
trimEdge = .25*ppd;             % edge of stimulus, in pix
trimSD= res-.25*ppd;            % trim whole-field SD estimates (in addition to size)
maxShift = 5;                   % absolute value of max shift
maxGain = 99;                   % range was set at 100
                
if      vox.eccen < minEccen  ...
        || vox.size < minSize ...
        || vox.size > maxSize ...
        || vox.params(3) > trimSD ...
        || vox.params(1) < trimEdge ...
        || vox.params(1) > res-trimEdge ...
        || vox.params(2) < trimEdge ...
        || vox.params(2) > res-trimEdge ...
        || vox.params(4) > maxGain ...
        || (length(vox.params)==65) && abs(vox.params)>maxShift ...
        || isempty(find(vox.betas>0)) ...
    trim = 1;
else
trim = 0; end

end

