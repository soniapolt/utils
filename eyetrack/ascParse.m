function [trial,info] = ascParse(ascFile,dataFile,saveTo)
% reads asc full file & sample file and aggregates by trial
% trial specification (ex. BLOCK %d, TRIAL %d, CONDITION %d) is taken from
% eyeInit.trialMessage, as are screen properties

%ascFile = '/Volumes/projects/behavFIE/prfRec/ascs/JJ190711.asc'; 
%dataFile = '/Volumes/projects/behavFIE/prfRec/data/prfRec_JJ_1back.mat'
load(dataFile);

[ascDir,fName,~]=fileparts(ascFile);
[samples] = ascSampleRead([ascDir '/' fName '_samples.asc']); % time, x, y pos in pixels

%%%% parse ASC events file for relevant information
fid = fopen(ascFile); trial = []; info = struct('fixation',[],'blink',[],'saccade',[]);
n = 1;
    
thisLine = fgets(fid);
    % initial scan - trial starts and all data
    while ischar(thisLine)
        %%% look for trial message, as specified in eyeInit file
        if(strfind(thisLine,eyeInit.trialMessage(1:5)))
                tmp =textscan(thisLine,['MSG %d ' eyeInit.trialMessage]);
                trial(n).start = tmp{1}; 
                trial(n).text = sprintf(eyeInit.trialMessage,tmp{2:4});
                trial(n).cond = tmp{4};
        elseif(strfind(thisLine,'TRIAL_END'))       
                tmp =textscan(thisLine,['MSG %d TRIAL_END']);
                trial(n).end = tmp{1};
                n=n+1;
        %%% look for calibration & validation markers   
        elseif strfind(thisLine,'!CAL CALIBRATION H')
           tmp =textscan(thisLine,['MSG %d !CAL CALIBRATION %s %s %s %s']);
           info.calib = tmp{5};
           info.eye = tmp{4};
        elseif strfind(thisLine,'!CAL VALIDATION H')
           tmp =textscan(thisLine,['MSG %d !CAL VALIDATION %s %s %s %s ERROR %.4f avg. %.4f max']);
           info.valid = tmp{5};
           info.errorAvgMax = [tmp{6} tmp{7}]; 
        elseif strfind(thisLine,'!CAL VALIDATION H')
           tmp =textscan(thisLine,['MSG %d !CAL VALIDATION %s %s %s %s ERROR %.4f avg. %.4f max']);
           info.valid = tmp{5};
           info.errorAvgMax = [tmp{6} tmp{7}]; 
           
        %%% look for event markers (saccades, fixations, blinks)
        elseif strfind(thisLine,'EFIX')
            tmp = textscan(thisLine,'EFIX %s %d %d');
            info.fixation = [info.fixation; tmp{2} tmp{3}]; % start and ends of this fixation 
        elseif strfind(thisLine,'ESACC')
            tmp = textscan(thisLine,'ESACC %s %d %d');
            info.saccade = [info.saccade; tmp{2} tmp{3}];
        elseif strfind(thisLine,'EBLINK')
            tmp = textscan(thisLine,'EBLINK %s %d %d');
            info.blink = [info.blink; tmp{2} tmp{3}];
            
        %%% pull sample rate, too
        elseif strfind(thisLine,'RATE')
            tmp = textscan(thisLine,'%s %s %s %s %f.0');
            info.rate = tmp{5}; 
        end
        thisLine = fgets(fid);
    end
    
    % parse samples into trial structure
    for n = 1:length(trial)
        trial(n).samples = samples(findBetween(samples(:,1),trial(n).start,trial(n).end),:);
    end
    
% parse fixations, saccades, and blinks into trial structure
f = trialFromTime([trial.start],[trial.end],info.fixation(:,1));
s = trialFromTime([trial.start],[trial.end],info.saccade(:,1));
b = trialFromTime([trial.start],[trial.end],info.blink(:,1));

for n = 1:length(trial)
    trial(n).fixations = double(info.fixation(find(f==n),:));
    trial(n).saccades = double(info.saccade(find(s==n),:));
    trial(n).blinks = double(info.blink(find(b==n),:));
end

if exist('saveTo','var')
   checkDir(fileparts(saveTo)); % check for existence of directory
   save(saveTo,'trial','info','eyeInit'); 
end

