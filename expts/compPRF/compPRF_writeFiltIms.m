function compPRF_writeFiltIms(which,session,exptDir,runs)
% edited from makeConIms, allowing us to make a full set of images,
% in order of presentation, for the pRF mapping stimulus in several
% different stimulus edits: binary contrast image, original photograph
% avg image, ~edge contrast energy
% this is now the messiest script in the universe. i am sorry, future self.

%clear all; close all;
%which = 2; session = 'SP181018'; exptDir = '/Volumes/projects/invPRF/'; runs = 1:7;
% addpath(genpath('/Volumes/invPRF/utils'));

% what kind of image processing will we do?
% 1 = binary
% 2 = photo (abs contrast)
% 3 = energy per edge 2017 paper (remove low frequency, rectify)
% 4 = energy per mrVista (jw 2008 authorship?), which ends up being
% near-identicl to #2 (just normalizes differently at the end
im.which = which; %
im.name = {'binary' 'photo' 'edge' 'otherEdge' 'internal'}; % edge isn't set up yet...

im.subj = session;
im.expt = 'compPRF';

% load in a .mat file from the experiment that was run
dataDir = fullfile(exptDir,im.expt,session,'Stimuli','output');
outputDir = [exptDir 'cssFit/stims/']; checkDir(outputDir);
%load('faceFront.mat');
fprintf('Will save to: %s\n',outputDir);

im.ppd = 30; % for images

im.runs = runs;

load([dataDir '/' im.expt '_1.mat']); % to set up

im.size = round(im.ppd*((params.grid-1)*params.gridSpaceDeg+params.faceSizeDeg));
im.size = im.size+(10-mod(im.size,10))+50+(params.faceSizeDeg*im.ppd); % round up to nearest 10 pixels, make sure 2-face stims fit (+another faceSize), add 50 buffer pix

gr = im.ppd*params.gridSpaceDeg*([1:params.grid]-ceil(params.grid/2));
[X,Y]=(meshgrid(gr));X=X';Y=Y';

%%% sample centers across, then down
im.centers = [Y(:)+im.size/2 X(:)+im.size/2];
im.diam = params.faceSizeDeg*im.ppd;


% small, big, two
condSizes{1} = [im.diam im.diam];
condSizes{2} = [2*im.diam im.diam];
condSizes{3} = [im.diam im.diam]; % each of two small faces

condIms{length(condition)} = [];
for r = im.runs
    %numConds =  length(condition)/length(unique([condition.pos]))
    load([dataDir '/' im.expt '_' num2str(r) '.mat']);
    if containsTxt(im.name{im.which},'internal') load('noHair.mat'); end % this should live in our utils directory
    for n = 1:length(face)
        face{n} = imresize(face{n},condSizes{1});
        bigFace{n} = imresize(face{n},condSizes{2});
    end
    %%% since trials are actually 2TRs each, we need to split up our struct to
    %%% be in TR units
    c = 1;
    for t = 1:length(trial)
        TR(c).cond = trial(t).cond;TR(c+1).cond = trial(t).cond;
        
        if TR(c).cond>0
            TR(c).IDs = trial(t).IDs(:,1:4);
            TR(c+1).IDs = trial(t).IDs(:,5:end);
        end
        c = c+2;
    end
    
    for n = 1:length(TR)
        thisIm = zeros(im.size,im.size);
        if TR(n).cond>0
            faces = [];
            for m = find(TR(n).IDs(1,:)) %ignore blanks within trialset
                % first face (we'll do this again for the two-face condition later)
                if condition(TR(n).cond).stim == 2
                faces = cat(3,faces,bigFace{TR(n).IDs(1,m)});
                else
                faces = cat(3,faces,face{TR(n).IDs(1,m)});
                end
            end
            faceM = mean(faces,3);
            if condition(TR(n).cond).numFaces == 2
                faces2 = [];
                for m = find(TR(n).IDs(2,:)) %ignore blanks within trialset
                    % first face (do this again for the two-face conditionlater
                    faces2 = cat(3,faces2,face{TR(n).IDs(2,m)});
                end
                faceM2 = mean(faces2,3);
            end
            
            if condition(TR(n).cond).numFaces == 1
                rect = CenterRectOnPoint([1 1 condSizes{condition(TR(n).cond).stim}],im.centers(condition(TR(n).cond).pos,1),im.centers(condition(TR(n).cond).pos,2));
            else
                rect = CenterRectOnPoint([1 1 im.diam im.diam],im.centers(condition(TR(n).cond).pos,1)-im.diam/2,im.centers(condition(TR(n).cond).pos,2));
                rect2 = CenterRectOnPoint([1 1 im.diam im.diam ],im.centers(condition(TR(n).cond).pos,1)+im.diam/2,im.centers(condition(TR(n).cond).pos,2));
            end
        if im.which == 1 % binary
            % insert disk at face location
            c=insertShape(zeros(im.diam,im.diam),'FilledCircle',[im.diam/2 im.diam/2 im.diam/2],'Color','White','Opacity',1);
            thisIm(rect(1):rect(3),rect(2):rect(4)) = c(:,:,1);
            if condition(TR(n).cond).numFaces == 2
            thisIm(rect2(1):rect2(3),rect2(2):rect2(4)) = c(:,:,1);
            end
        elseif im.which == 2 || im.which == 5% photo
            % subtract background, take absolute value, divide by max
            faceM = abs(faceM-params.backgroundColor);
            thisIm(rect(1):rect(3),rect(2):rect(4)) = faceM;
            if condition(TR(n).cond).numFaces == 2
            faceM2 = abs(faceM2-params.backgroundColor);    
            thisIm(rect2(1):rect2(3),rect2(2):rect2(4)) = faceM2;    
            end
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

condAvg = condAvg/max(condAvg(:));

save([outputDir im.subj '_condAvg_' im.name{im.which} '.mat'],'condAvg','im');
implay(condAvg);
%end