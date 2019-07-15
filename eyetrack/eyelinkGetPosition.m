function [gazeX,gazeY] = eyelinkGetPosition(el,gazeX,gazeY,win)
% 
% [win,rect]=screenInit; gazeX = []; gazeY = [];
% %%% move xc and yc off screen center if needed (more relevant for the 7T scanner...)
% xc = rect(3)/2;
% yc = rect(4)/2;

% grab the eye position from the eyetracker in real time
% if we give it the window, it will also draw a trace
eyeUsed = Eyelink('EyeAvailable');
[w, h]=Screen('WindowSize', win);

%while 1
if Eyelink('NewFloatSampleAvailable') > 0;
    % Make the new sample into an event struct
    sample = Eyelink('NewestFloatSample');
    % Find current x and y
    x = sample.gx(eyeUsed+1);
    y = sample.gy(eyeUsed+1);
                
    % if there is no missing data add to gaze vars
    if x~=el.MISSING_DATA && y~=el.MISSING_DATA && sample.pa(eyeUsed+1)>0;
        gazeX = [gazeX x];
        gazeY = [gazeY y];
    end
end

    if exist('win','var');
        trace = 20; % length of samples that we will use for drawing
        if length(gazeX) > trace
        Screen('DrawDots',win,[gazeX(end-trace:end);gazeY(end-trace:end)],2,[200 0 0]); end
        %Screen('Flip',win);
    end
end

