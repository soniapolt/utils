
function [bin,counts,indX,indY] = binPRFcenters(vox,edges)
% vox is a structure of v voxels with  a params field
% this function bins our pRFs by centers, assuming equally-sized x and y
% -dim bins. it returns a structure of the bin [(1,1) top left of visual
% field, (n,n) bottom left] containing the voxel indices in each bin
%
% clear all;
%
% % for testing
% load('/Volumes/invPRF/cssFit/fits/invPRF3/SP180301/photo/SP180301_f_lh_V1_cssShift.mat')
% vox = fits(1).vox; clear fits;
% edges = [0:30:330];
centers = edges(1:end-1)+diff(edges)/2;

% extract X and Y from this annoying structure
for v = 1:length(vox)
    XYs(v,:) = [vox(v).params(2) vox(v).params(1)];
end
[~, indX] = histc(XYs(:,1),edges);  % x binning
[~, indY] = histc(XYs(:,2),edges);  % y binning
% x binning

b = 1;

% struct with linear indexing
for y = 1:length(centers)
    for x = 1:length(centers)
        bin(b).centerXY = [centers(y),centers(x)];
        bin(b).vox = intersect(find(indX==x),find(indY==y));
        bin(b).count = length(bin(b).vox);
        b=b+1;
    end
end

counts = reshape([bin.count],length(centers),length(centers));
