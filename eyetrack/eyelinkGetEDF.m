function eyelinkGetEDF(oldName,newName,outputDir)
% grab edf file from the eyelink
% oldName is usually 'tmp' - since edf files cannot be more than 8 chars
% long natively, we will not set it before

Eyelink('Command', 'set_idle_mode'); WaitSecs(0.5); Eyelink('CloseFile');
try % download edfFile
    status=Eyelink('ReceiveFile');
    if status > 0
        fprintf('Receiving EDF file ''%s'', status: %d\n',oldName,status);
    end
catch
    fprintf('Problem receiving EDF file ''%s''\n', oldName);
end

% rename edfFile
try
    fprintf('Renaming %s to %s...\n', oldName, newName);
    copyfile([oldName '.edf'], [newName '.edf'], 'f');
catch
    fprintf('Problem renaming EDF file to %s  - it is still called %s.\n',newName,oldName);
end

% move edfFile
if exist('outputDir','var')
    checkDir(outputDir)
try
    movefile([newName '.edf'],outputDir);     % move this to appropriate folder
    fprintf('Moving %s to %s...\n', newName, outputDir);
catch
    fprintf('Problem moving EDF file to %s  - it will stay in %s.\n',outputDir,pwd);
end
end

