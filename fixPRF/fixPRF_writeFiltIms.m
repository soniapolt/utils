function fixPRF_writeFiltIms(which,session,exptDir,runs)
% edited from makeConIms, allowing us to make a full set of images,
% in order of presentation, for the pRF mapping stimulus in several
% different stimulus edits: binary contrast image, original photograph
% avg image, ~edge contrast energy

%clear all; close all;
% addpath(genpath('/Volumes/invPRF/utils'));

% what kind of image processing will we do?
% 1 = binary
% 2 = photo (abs contrast)
% 3 = energy per edge 2017 paper (remove low frequency, rectify)
% 4 = energy per mrVista (jw 2008 authorship?), which ends up being
% near-identicl to #2 (just normalizes differently at the end
im.which = which; %
im.name = {'binary' 'photo' 'edge'};

im.subj = session;
im.expt = 'fixPRF';

% load in a .mat file from the experiment that was run
dataDir = fullfile(exptDir,im.expt,session,'Stimuli','output');
outputDir = [exptDir 'cssFit/stims/']; checkDir(outputDir);
%load('faceFront.mat');
fprintf('Will save to: %s\n',outputDir);

im.ppd = 30; % for images

im.runs = runs;

load([dataDir '/' im.expt '_1.mat']); % to set up

im.size = round(im.ppd*((params.grid-1)*params.gridSpaceDeg+params.faceSizeDeg));
im.size = im.size+(10-mod(im.size,10))+50; % round up to nearest 10 pixels, add 1 deg

gr = im.ppd*params.gridSpaceDeg*([1:params.grid]-ceil(params.grid/2));
[X,Y]=(meshgrid(gr));X=X';Y=Y';

%%% sample centers across, then down
im.centers = [Y(:)+im.size/2 X(:)+im.size/2];
im.diam = params.faceSizeDeg*im.ppd;



% inverted,normal
condSizes{1} = [im.diam im.diam];
condSizes{2} = [im.diam im.diam];

condIms{length(condition)} = [];
for r = im.runs
    %numConds =  length(condition)/length(unique([condition.pos]))
    load([dataDir '/' im.expt '_' num2str(r) '.mat']);
    for n = 1:length(face)
        face{n} = imresize(face{n},condSizes{1});
    end
    %%% since trials are actually 2TRs each, we need to split up our struct to
    %%% be in TR units
    c = 1;
    for t = 1:length(trial)
        TR(c).cond = trial(t).cond;TR(c+1).cond = trial(t).cond;
        
        if TR(c).cond>0
            TR(c).IDs = trial(t).IDs(1:4);
            TR(c+1).IDs = trial(t).IDs(5:end);
        end
        c = c+2;
    end
    
    for n = 1:length(TR)
        thisIm = zeros(im.size,im.size);
        if TR(n).cond>0
            faces = [];
            for m = find(TR(n).IDs) %ignore blanks within trialset
                if condition(TR(n).cond).stim==1 % inverted
                    faces = cat(3,faces,flipud(face{TR(n).IDs(m)}));
                elseif condition(TR(n).cond).stim==2 % normal
                    faces = cat(3,faces,face{TR(n).IDs(m)});
                end
            end
            faceM = mean(faces,3);
            rect = CenterRectOnPoint([1 1 condSizes{condition(TR(n).cond).stim}],im.centers(condition(TR(n).cond).pos,1),im.centers(condition(TR(n).cond).pos,2));
            if im.which == 1 % binary
                % insert disk at face location
                c=insertShape(zeros(im.diam,im.diam),'FilledCircle',[im.diam/2 im.diam/2 im.diam/2],'Color','White','Opacity',1);
                thisIm(rect(1):rect(3),rect(2):rect(4)) = c(:,:,1);
            elseif im.which == 2 % photo
                % subtract background, take absolute value, divide by max
                faceM = abs(faceM-params.backgroundColor);
                thisIm(rect(1):rect(3),rect(2):rect(4)) = faceM;
            elseif im.which == 3 % energy per edge 2017
                % convolve image with guassian kernel (SD = 6 in orig)
                % abs(orig - blurred), divide by max
                
                ii = ones(im.size,im.size)*params.backgroundColor;
                ii(rect(1):rect(3),rect(2):rect(4)) = faceM;
                filtFace = conv2(make2DGaussian(im.diam,im.diam,.2*im.ppd),ii);
                centerFace = round(size(filtFace,1)/2+.5);
                filtCrop = filtFace(centerFace-im.size/2:centerFace+im.size/2-1,centerFace-im.size/2:centerFace+im.size/2-1);
                %images(:,:,n) = abs(ii - filtCrop);
                hack = abs(ii - filtCrop);
                hack(1:20,:) = 0; hack(:,1:20) = 0;
                hack(end-20:end,:) = 0; hack(:,end-20:end) = 0;
                thisIm = hack;
            elseif im.which == 4 % energy per mrVista
                % subtract background intensity
                % rectify
                % divide by max (in a slightly different way that others - done
                % after all ims are aggregated
                thisIm(rect(1):rect(3),rect(2):rect(4)) = sqrt((faceM-params.backgroundColor).^2);
            end
            if isempty(condIms{TR(n).cond})
                condIms{TR(n).cond} = thisIm;
            else condIms{TR(n).cond} = cat(3,condIms{TR(n).cond},thisIm);
            end
        end
    end
end

% average over runs
for n = 1:length(condIms)
    condAvg(:,:,n) =  mean(condIms{n},3);
end

% normalize
if im.which == 4
    maxEnergy = max(max(condAvg(:))-params.backgroundColor,params.backgroundColor-min(condAvg(:)));
    condAvg = condAvg/maxEnergy;
else
    condAvg = condAvg/max(condAvg(:));
end

save([outputDir im.subj '_condAvg_' im.name{im.which} '.mat'],'condAvg','im');
%implay(condIms);
end