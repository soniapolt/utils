% makes contrast maps from whatever 
clear all; close all;
% load in a .mat file from the experiment that was run
load('/Users/Sonia/Desktop/invPRF Development/data/invPRF_SP171101_run1.mat')
saveFile = 'SP_invPRF_conIms.mat';

im.ppd = 30; % for images
%params.gridSpaceDeg = 1; % for TH's scans, this was not implemented correctly

im.size = round(im.ppd*((params.grid-1)*params.gridSpaceDeg+params.faceSizeDeg));
im.size = im.size+(10-mod(im.size,10)); % round up to nearest 10 pixels

gr = im.ppd*params.gridSpaceDeg*([1:params.grid]-ceil(params.grid/2));
[X,Y]=(meshgrid(gr));X=X';Y=Y';

%%% sample centers across, then down
im.centers = [X(:)+im.size/2 Y(:)+im.size/2];
im.rad = params.faceSizeDeg/2*im.ppd;

im.black = zeros(im.size,im.size,3);

for n = 1:length(im.centers)
c = insertShape(im.black,'FilledCircle',[im.centers(n,1) im.centers(n,2) im.rad],'Color','White','Opacity',1);
im.con(:,:,n) = c(:,:,1);
imshow(im.con(:,:,n));
WaitSecs(2);
end


%%% stim pre-processing to minimize comp time for pRF fitting

% resize the stimuli to 100 x 100 (to reduce computational time)
% temp = zeros(100,100,size(invPRFcon,3));
% for p=1:size(invPRFcon,3)
%   temp(:,:,p) = imresize(invPRFcon(:,:,p),[100 100],'cubic');
% end
% stimulus = temp; clear invPRFcon;


% reshape stimuli into a "flattened" format: 25 stimuli x res x res positions
stimulus = reshape(im.con,im.size*im.size,length(im.centers))';

save(saveFile,'im','stimulus');