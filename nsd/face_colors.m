function [cmap] = face_colors(inds)
% facebody color map 
if ~exist('inds','var') inds = 1:5;end
cmap = ...
[255 200 0;...      % yellow - IOG faces
 255 100 0;...      % orange - pFus faces
 250 50 147;...     % pink - mFus faces
 145 0 115;...      % purple - mTL faces
 170 0 0;...        % red - aTL faces
 ]./255; 
cmap = cmap(inds,:);
end