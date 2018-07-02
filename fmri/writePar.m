function writePar(session,exptDir,expt,numRuns)
% write a parfile for mrVista
% clear all;

% expt = 'invPRF3';
% session = 'MG180213';
% numRuns = [1:8];

%outputDir=fullfile('/Volumes','kalanit','biac2','kgs','projects',expt,'data',session,'stim','parfiles');
inputDir = [exptDir session '/Stimuli/output'];
outputDir = [exptDir session '/Stimuli/parfiles'];

% idcs   = strfind(exptDir,'/');
% expt = exptDir(idcs(end)+1:end); 

condColors = {[50 50 50];[66 134 244]/255; [47 145 49]/255; [117 52 216]/255}; % grey, blue, green, purple

for r = numRuns
    parname = [session '_' expt '_run' num2str(r) '.par'];
    matname = [inputDir '/' expt '_' num2str(r) '.mat'];
    
    load(matname);
    fid = fopen(fullfile(outputDir,parname), 'w');
    %fid = fopen(parname, 'w');
    for t = 1:length(trial)
        fprintf(fid, '%d \t %d \t', trial(t).onset, trial(t).cond);
        if trial(t).cond==0 fprintf(fid, '%s \t', 'baseline');
            fprintf(fid, '%i %i %i \n', condColors{1});
        else fprintf(fid, '%s \t', condition(trial(t).cond).name);
            fprintf(fid, '%i %i %i \n', condColors{condition(trial(t).cond).num+1}); end
    end
    fclose(fid);
end
end