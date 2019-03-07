function faceLasso_sherlock(expt,subj,stimNum,minR2,ppd,ROI,weight)

% adding sherlock functionality to faceRidge_fitWeights
% in this version, fit the weights only (first subtracting out the
% effects of the stimulus)
% fits one subj/ROI/stimNum at a time for speed

% experiment and session
reg.expt = expt;
reg.subjs = {subj};
reg.whichModel = 'cssExpN';
reg.whichStim ='photo'; reg.minR2 = minR2;
reg.weight = weight; %binary, whether we weight our fits by the R2 or not
reg.ppd = ppd;

reg.ROI = ROI;
reg.hems = {'rh' 'lh'};

% define paths
[pRFdir,regDir,regFile] = lassoDirs('',expt,subj,ppd,ROI,1,weight);

%load prfset for these fits
load([pRFdir '/' expt '_' reg.whichModel '_' reg.whichStim '_' hemText(reg.hems) '_r2-' num2str(reg.minR2) '.mat']);

ROInum = cellNum(reg.ROI,info.ROIs);
subjNum = cellNum(reg.subjs,info.subjs);
% we're fitting one subject at a time
fits = subj(subjNum).roi(ROInum).fits;
numVox = length(fits(1).vox);

load(['~/' fits(1).stim]);
reg.stim = fits(1).stim;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bCond = 2;  % base cond is upright
cCond = 1;  % comp cond is inverted
cStim = fits(cCond).condNums; %should be inverted (<26)
bStim = fits(bCond).condNums;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% simulation properties
 reg.imSize = reg.ppd*im.size/im.ppd; % pulls from stim/condAvg

for t = stimNum % this code fits/saves one stim at a time, but this keeps upright/inverted correspondence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start sim - no plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% resize our stimulus image, show it
invIm = imresize(condAvg(:,:,cStim(t)),[reg.imSize,reg.imSize]);
invIm=invIm-min(invIm(:)); %normalize to range from 0 to 1
reg.invIm=invIm./max(invIm(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% image region that will drive responses, when multiplied with the invIm
[X,Y]=meshgrid(1:reg.imSize,1:reg.imSize); mid = reg.imSize/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize feature mask and grab our PRFs

% coverage = []; imCoverage = []; response = [];
for v = 1:numVox
   reg.coverage(v,:,:) = flipud(PRF(X,Y,fits(bCond).vox(v).XYdeg(1)*reg.ppd+mid,fits(bCond).vox(v).XYdeg(2)*reg.ppd+mid,fits(bCond).vox(v).size*reg.ppd));
   reg.response(v) = (fits(cCond).vox(v).betas(cStim(t))/fits(bCond).vox(v).gain);%^(1/fits(bCond).vox(v).params(end));
   reg.imCoverage(v,:,:) = reg.invIm.* squeeze(reg.coverage(v,:,:));
end
% reg.coverage{t} = coverage; reg.response{t} = response; reg.imCoverage{t}=imCoverage;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% regression time
vectCoverage = reshape(reg.coverage,numVox,size(reg.coverage,2)*size(reg.coverage,3));
reg.response = reg.response-mean(reg.response(:))/std(reg.response(:));

% multiply the coverage by our image so we're just regressing the weighting
reg.imCoverage = reshape(reg.imCoverage,numVox,size(reg.coverage,2)*size(reg.coverage,3));

% cross-validated ridge regression

fprintf('Starting ridgeFit %s %s stim #%d...will save to %s\n',ROI,reg.subjs{1},stimNum,...
[regDir '/' regFile '_' num2str(stimNum) '.mat']);

% provide weighting of pRFs by R2fit, or not
    if reg.weight
        wts = [fits(bCond).vox.r2];
    else wts = ones(1,numVox);
    end
        
    % cross-validated lasso regression
    [reg.betas,reg.stats] = lasso(vectCoverage,response','CV',10,'Options',statset('UseParallel',1),'Weights',wts');
    reg.timeFit = toc;

checkDir(regDir);
save([regDir '/' regFile '_' num2str(stimNum) '.mat'],'reg');
fprintf('lassoFit %s %s stim #%d finished at %s, took %s mins\n\n',reg.subjs{1},ROI,stimNum,datestr(now),num2str(reg.timeFit/60));
end
