function [modelfun, model, metric, resampling] = init_cssExpN(expN,stimSize,hem,ppd)
% expN = set term for compressive non-linearity
% stimSize = in pixels

% the parameters of the CSS model are [R C S G N] where
%   R is the row index of the center of the 2D Gaussian
%   C is the column index of the center of the 2D Gaussian
%   S is the standard deviation of the 2D Gaussian
%   G is a gain parameter

[d,xx,yy] = makegaussian2d(stimSize,2,2,2,2);
if strcmp(hem,'lh')==1
    seed = [.5*stimSize, .75*stimSize, ppd,  1];
else seed = [.5*stimSize, .25*stimSize, ppd, 1];
end

% bounds currently: X/Y can't be outside of stimulus, size can't be less
% than 0.1dva or bigger than stimulus, and positive gain (within reason)

bounds =    [1          1           ppd/10      0; ...
            stimSize-1  stimSize-1  stimSize    100];

boundsFIX = bounds; 
boundsFIX(1,4) = NaN; % don't fit the size initially

modelfun = @(pp,dd) (pp(4) * (dd*vflatten(makegaussian2d(stimSize,pp(1),pp(2),abs(pp(3)),abs(pp(3)),xx,yy,0,0) / (2*pi*abs(pp(3))^2))) .^ expN);

% define the final model specification.
model = {{seed       boundsFIX   modelfun} ...
    {@(ss) ss   bounds      @(ss) modelfun}};

resampling = 0; % just fit the data (no cross-validation nor bootstrapping).

% define the metric that we will use to quantify goodness-of-fit.
metric = @(a,b) calccod(a,b,[],[],0);

end