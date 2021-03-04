function [roi_names, roi_colors, short_names ]= facebody_rois(ind)
% function [roi_names, roi_colors] = facebody_rois(ind)
%   returns cell string of {N} face/body rois, and corresponding [nx3]
%   array of colors
roi_names =  {'IOG-faces' 'pFus-faces' 'mFus-faces' 'mTL-faces' 'aTL-faces' 'pOTS-bodies' 'OTS-bodies' 'aOTS-bodies' 'aTL-bodies'};
short_names = {'IOG-f' 'pFus-f' 'mFus-f' 'mTL-f' 'aTL-f' 'pOTS-b' 'OTS-b' 'aOTS-b' 'aTL-b'};
roi_colors = vertcat(face_colors, body_colors);
if exist('ind','var')
    roi_names = roi_names{ind}; 
    roi_colors = roi_colors(ind,:);
    short_names = short_names{ind};
end
    
end

