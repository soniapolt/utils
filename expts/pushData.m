function pushData (locDir,volDir,fileType)
% pushing local (Users/kalanit/Experiment) data to server (Volumes/projects/)
% assumes that you are starting from: Users/kalanit/Experiments/Sonia/ and
% pushing to: Volumes/projects/
% input: exptName; assumed identical between them, with identical data structure
% input: dataCell; cell of strings with

if ~isdir(volDir) error('Server is not mounted! This function needs to see /Volumes/projects/'); end

    locFiles = cleanFileNames(locDir,fileType);
    volFiles = cleanFileNames(volDir,fileType);
    for m = 1:length(locFiles)
        if ~sum(strcmp(volFiles,locFiles{m}))% if file isn't already on the server
            move = input(sprintf('Move file %s? [1=Yes, 0=Skip] ',locFiles{m}));
            if move 
                copyfile([locDir '/' locFiles{m}], [volDir '/' locFiles{m}], 'f');
                fprintf('...Done.\n'); end
        % else fprintf('File %s already exists on the server...\n',locFiles{m});
        end
    end
end

%end

