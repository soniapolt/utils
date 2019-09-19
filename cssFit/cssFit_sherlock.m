function timeFit = cssFit_sherlock(whichCSS,expt,session, stimName, ROI, hem)
% general function, which allows us to fit multiple versions of the cssFit
% model

tic
% load data & stim
whichStim = ['stims/' session '_condAvg_' stimName '.mat'];
load(whichStim); % downsampled and reshaped
stimSize = im.size;

% rectify negative betas?
rectNegBetas = 0;

switch expt
    case 'invPRF3'
        fits = struct('session',session,'cond',{'Inverted' 'MisAligned' 'Upright'},'condNums', {[1:25],[26:50],[51:75]},'res',im.size,...
            'stim',whichStim,'fitTime',date,'ppd',im.ppd,'whichModel',[],'rectBetas',rectNegBetas);
    case 'compPRF'
        fits = struct('session',session,'cond',{'Small' 'Big' 'Two'},'condNums', {[1:25],[26:50],[51:75]},'res',im.size,...
            'stim',whichStim,'fitTime',date,'ppd',im.ppd,'whichModel',[],'rectBetas',rectNegBetas);
    case 'fixPRF'
        fits = struct('session',session,'cond',{'Inverted' 'Upright'},'condNums', {[1:25],[26:50]},'res',im.size,...
            'stim',whichStim,'fitTime',date,'ppd',im.ppd,'whichModel',[],'rectBetas',rectNegBetas);
end

for c = 1:length(fits)
    stimulus{c} = reshape(condAvg(:,:,fits(c).condNums),im.size*im.size,length(fits(c).condNums))';
end

% the parameters of the CSS model are [R C S G N] where
%   R is the row index of the center of the 2D Gaussian
%   C is the column index of the center of the 2D Gaussian
%   S is the standard deviation of the 2D Gaussian
%   G is a gain parameter
%   N is the exponent of the power-law nonlinearity
%   B is the baseline shift

switch whichCSS
    case 'cssExpN'
        expN = .2;
        modelName = ['singleGauss CSS + fixed exponent: ' num2str(expN)];
        [fits.parNames] = deal({'Y','X','sd','gain'});
        [fits.expN] = deal(expN);
        [modelfun, model, metric, resampling] = init_cssExpN(expN,stimSize,hem,im.ppd);
        
    case 'cssShift'
        modelName = 'singleGauss CSS + baseline shift';
        [fits.parNames] = deal({'Y','X','sd','gain','exp','shift'});
        [modelfun, model, metric, resampling] = init_cssShift(stimSize,0,hem,im.ppd); % 0 = don't force shift to be neg.
        
    case 'kayCSS'
        modelName = 'kay CSS, no baseline shift';
        [fits.parNames] = deal({'Y','X','sd','gain','exp'});
        [modelfun, model, metric, resampling] = init_kayCSS(stimSize,hem,im.ppd);
    
    case 'flipCSSn'
        expN = .2;
        modelName = ['flip CSS + fixed exponent: ' num2str(expN)];
        [fits.parNames] = deal({'Y','X','sd','gain','wNose','wMouth','wSkin','wHair','wEyes'});
        [fits.expN] = deal(expN);
        [modelfun1, model1, metric1, resampling1] = init_flipCSSn(expN,stimSize,hem,im.ppd,1);
        [modelfun, model, metric, resampling] = init_flipCSSn(expN,stimSize,hem,im.ppd,0);
   case 'inflipCSSn'
        expN = .2;
        modelName = ['int features flip CSS + fixed exponent: ' num2str(expN)];
        [fits.parNames] = deal({'Y','X','sd','gain','wNose','wMouth','wSkin','wEyes'});
        [fits.expN] = deal(expN);
        [modelfun1, model1, metric1, resampling1] = init_inflipCSSn(expN,stimSize,hem,im.ppd,1);
        [modelfun, model, metric, resampling] = init_inflipCSSn(expN,stimSize,hem,im.ppd,0);
        
    case 'tempCSSn'
        expN = .2;
        modelName = ['template CSS + fixed exponent: ' num2str(expN)];
        [fits.parNames] = deal({'Y','X','sd','gain','wNose','wMouth','wSkin','wHair','wEyes'});
        [fits.expN] = deal(expN);
        [modelfun, model, metric, resampling] = init_tempCSSn(expN,stimSize,hem,im.ppd); 
   case 'intempCSSn'
        expN = .2;
        modelName = ['int features template CSS + fixed exponent: ' num2str(expN)];
        [fits.parNames] = deal({'Y','X','sd','gain','wNose','wMouth','wSkin','wEyes'});
        [fits.expN] = deal(expN);
        [modelfun, model, metric, resampling] = init_intempCSSn(expN,stimSize,hem,im.ppd);  
    case 'tempCSS'            
        modelName = 'template CSS model';
        [fits.parNames] = deal({'Y','X','sd','gain','exp','wNose','wMouth','wSkin','wHair','wEyes'});
        [modelfun, model, metric, resampling] = init_tempCSS(stimSize,hem,im.ppd);
end

[fits.whichModel] = deal(modelName);
% specify fits data and output
thisROI= vpnlROI([hem '_' ROI],session(1:2),expt);
[dataName, fitsName] = fitsDirsSherlock(expt,session,stimName,thisROI,whichCSS);
checkDir(dirOf(fitsName));
load(dataName);

for c = 1:length(fits)
    fits(c).ROIname = thisROI;
    fits(c).vox = [];
    for v = 1:size(output.betas,2)
        fits(c).vox(v).betas = output.betas(fits(c).condNums,v);
        fits(c).vox(v).sems = output.sems(fits(c).condNums,v);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % finally, construct the options struct that will be passed to fitnonlinearmodel.m
        if rectNegBetas
            opt = struct( ...
                'stimulus',    stimulus{c}, ...
                'data',        posrect(fits(c).vox(v).betas), ...
                'model',       {model}, ...
                'resampling',  resampling, ...
                'metric',      metric, ...
                'dosave',      'modelfit',...
                'optimoptions', {{'Display' 'off' 'UseParallel' 0}}...
                );
            
        elseif containsTxt(whichCSS,'flip') && strcmp(fits(c).cond,'Inverted')
            % model1 has masks inverted
            opt = struct( ...
                'stimulus',    stimulus{c}, ...
                'data',        fits(c).vox(v).betas, ...
                'model',       {model1}, ...
                'resampling',  resampling1, ...
                'metric',      metric1, ...
                'dosave',      'modelfit',...
                'optimoptions', {{'Display' 'off' 'UseParallel' 0}}...
                );      
        else
            opt = struct( ...
                'stimulus',    stimulus{c}, ...
                'data',        fits(c).vox(v).betas, ...
                'model',       {model}, ...
                'resampling',  resampling, ...
                'metric',      metric, ...
                'dosave',      'modelfit',...
                'optimoptions', {{'Display' 'off' 'UseParallel' 0}}...
                );
                   end 
            
            %%% fit the model
            results = fitnonlinearmodel(opt);
            fits(c).vox(v).results = results;
            fits(c).vox(v).params = results.params;
            fits(c).vox(v).r2 = results.trainperformance;
            fits(c).vox(v).modelfit = results.modelfit;
            
            % if mod(v,20)==0
            %    save(fitsName,'fits');
            % end

    end
    save(fitsName,'fits');
    timeFit = toc;
    fprintf('%s modelFit finished %s %s%s at %s, took %s mins\n',whichCSS,session,hem,ROI,datestr(now),num2str(timeFit/60));
end

