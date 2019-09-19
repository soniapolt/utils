function [modelfun, model, metric, resampling] = init_inflipCSSn(expN,stimSize,hem,ppd,inv)

% the parameters of the CSS model are [R C S G N] where
%   R is the row index of the center of the 2D Gaussian
%   C is the column index of the center of the 2D Gaussian
%   S is the standard deviation of the 2D Gaussian
%   G is a gain parameter
%   N is the exponent of the power-law nonlinearity
% additionally, we will fit 5 weights that scale the stimulus image:
%   'wNose','wMouth','wSkin','wHair','wEyes'

[d,xx,yy] = makegaussian2d(stimSize,2,2,2,2);
if strcmp(hem,'lh')==1
    seed = [.5*stimSize .75*stimSize ppd 1 .5 .5 .5 .5];
else seed = [.5*stimSize .25*stimSize ppd 1 .5 .5 .5 .5];
end

% bounds currently: X/Y can't be outside of stimulus, size can't be less
% than 0.1dva or bigger than stimulus, and gain/expt is positive/reasonable
% weights must be between 0 and 1

bounds = [  1           1           ppd/10      0       0   0   0   0;...
            stimSize-1  stimSize-1  stimSize    100     1   1   1   1];

boundsFIX = bounds; boundsFIX(:,5:end) = NaN; % don't fit  weights initially

if inv load('tmpMasksInv.mat'); else
load('tmpMasks.mat'); end
%figure;
masks(4) = []; % do not use the hair mask
for m = 1:length(masks)
    msk = masks{m};
    %subplot(1,length(masks),m); imagesc(msk(:,:,5));
    mm{m} = reshape(msk(:,:,1:25),size(masks{1},1)^2,25)';
end

% mm is a struct of masks
modelfun = @(pp,dd) pp(4)*((dd.*[mm{1}*pp(5)+mm{2}*pp(6)+mm{3}*pp(7)+mm{4}*pp(8)]*...
    vflatten(makegaussian2d(stimSize,pp(1),pp(2),pp(3),pp(3),xx,yy,0,0)/(2*pi*pp(3)^2))).^expN);

% define the final model specification.
model = {{seed       boundsFIX   modelfun} ...
    {@(ss) ss   bounds      @(ss) modelfun}};

resampling = 0; % just fit the data (no cross-validation nor bootstrapping).

% define the metric that we will use to quantify goodness-of-fit.
metric = @(a,b) calccod(a,b,[],[],0);

end