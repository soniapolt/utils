function faceRidge_sherlock(expt,subj,stimNum,minR2,ppd,ROI)

% adding sherlock functionality to faceRidge_fitWeights
% in this version, fit the weights only (first subtracting out the
% effects of the stimulus)
% fits one subj/ROI/stimNum at a time for speed

% experiment and session
ridge.expt = expt;
ridge.subjs = {subj};
ridge.whichModel = 'cssExpN';
ridge.whichStim ='photo'; ridge.minR2 = minR2;
ridge.kRange = 0:50:6000;
ridge.ppd = ppd;

ridge.ROI = ROI;
ridge.hems = {'rh' 'lh'};

% define paths
[pRFdir,ridgeDir,ridgeFile] = ridgeDirs('',expt,subj,ppd,ROI,1);

%load prfset for these fits
load([pRFdir '/' expt '_' ridge.whichModel '_' ridge.whichStim '_' hemText(ridge.hems) '_r2-' num2str(ridge.minR2) '.mat']);

ROInum = cellNum(ridge.ROI,info.ROIs);
subjNum = cellNum(ridge.subjs,info.subjs);
% we're fitting one subject at a time
fits = subj(subjNum).roi(ROInum).fits;
numVox = length(fits(1).vox);

load(['~/' fits(1).stim]);
ridge.stim = fits(1).stim;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bCond = 2;  % base cond is upright
cCond = 1;  % comp cond is inverted
cStim = fits(cCond).condNums; %should be inverted (<26)
bStim = fits(bCond).condNums;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% simulation properties
 ridge.imSize = ridge.ppd*im.size/im.ppd; % pulls from stim/condAvg

for t = stimNum % this code fits/saves one stim at a time, but this keeps upright/inverted correspondence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start sim - no plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% resize our stimulus image, show it
invIm = imresize(condAvg(:,:,cStim(t)),[ridge.imSize,ridge.imSize]);
invIm=invIm-min(invIm(:)); %normalize to range from 0 to 1
ridge.invIm=invIm./max(invIm(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% image region that will drive responses, when multiplied with the invIm
[X,Y]=meshgrid(1:ridge.imSize,1:ridge.imSize); mid = ridge.imSize/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize feature mask and grab our PRFs

% coverage = []; imCoverage = []; response = [];
for v = 1:numVox
   ridge.coverage(v,:,:) = flipud(PRF(X,Y,fits(bCond).vox(v).XYdeg(1)*ridge.ppd+mid,fits(bCond).vox(v).XYdeg(2)*ridge.ppd+mid,fits(bCond).vox(v).size*ridge.ppd));
   ridge.response(v) = (fits(cCond).vox(v).betas(cStim(t))/fits(bCond).vox(v).gain);%^(1/fits(bCond).vox(v).params(end));
   ridge.imCoverage(v,:,:) = ridge.invIm.* squeeze(ridge.coverage(v,:,:));
end
% ridge.coverage{t} = coverage; ridge.response{t} = response; ridge.imCoverage{t}=imCoverage;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% regression time
vectCoverage = reshape(ridge.coverage,numVox,size(ridge.coverage,2)*size(ridge.coverage,3));
ridge.response = ridge.response-mean(ridge.response(:))/std(ridge.response(:));

% multiply the coverage by our image so we're just regressing the weighting
ridge.imCoverage = reshape(ridge.imCoverage,numVox,size(ridge.coverage,2)*size(ridge.coverage,3));

% cross-validated ridge regression

fprintf('Starting ridgeFit %s %s stim #%d...will save to %s\n',ROI,ridge.subjs{1},stimNum,...
[ridgeDir '/' ridgeFile '_' num2str(stimNum) '.mat']);

tic;
[betas,ridge.chosenK,ridge.allSSE] = ridgeCV(ridge.response',ridge.imCoverage,ridge.kRange);
ridge.timeFit = toc;

bb = betas(1:end,:); bb = squeeze(mean(bb,2));
ridge.bb = reshape(bb,size(ridge.coverage,2),size(ridge.coverage,3));

checkDir(ridgeDir);
save([ridgeDir '/' ridgeFile '_' num2str(stimNum) '.mat'],'ridge');
fprintf('ridgeFit %s %s stim #%d finished at %s, took %s mins\n\n',ridge.subjs{1},ROI,stimNum,datestr(now),num2str(ridge.timeFit/60));
end
