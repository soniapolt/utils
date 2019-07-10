function eyelinkGetEDF(edfName,outputDir)
% grab edf file from the eyelink
if ~exist('outputDir','var') outputDir = pwd; end
checkDir(outputDir);

Eyelink('Command', 'set_idle_mode'); WaitSecs(0.5); Eyelink('CloseFile');
    try % download edfFile
        status=Eyelink('ReceiveFile');
        if status > 0
            fprintf('Receiving EDF file ''%s'', status: %d\n',edfName,status);
        end
    catch
        fprintf('Problem receiving EDF file ''%s''\n', edfName);
    end
    try
        movefile([edfName '.edf'],outputDir);     % move this to appropriate folder
    catch
        fprintf('Problem moving EDF file to %s  - it will stay in %s.\n',outputDir,pwd); 
    end
end

