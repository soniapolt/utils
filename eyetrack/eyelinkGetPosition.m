function [gazeX,gazeY] = eyelinkGetPosition(el,gazeX,gazeY,win,corrX,corrY)
% [gazeX,gazeY] = eyelinkGetPosition(el,gazeX,gazeY,win,plotGaze)
% gets current gaze position and optionally plots it for the subject

% grab the eye position from the eyetracker in real time
% if we give it the window, it will also draw a trace

if ~exist('corrX','var') corrX = 0; end
if ~exist('corrY','var') corrY = 0; end
%if ~exist('win','var') win = []; end

eyeUsed = Eyelink('EyeAvailable');

%while 1
if Eyelink('NewFloatSampleAvailable') > 0
    % Make the new sample into an event struct
    sample = Eyelink('NewestFloatSample');
    % Find current x and y
    x = sample.gx(eyeUsed+1);
    y = sample.gy(eyeUsed+1);
                
    % if there is no missing data add to gaze vars
    if x~=el.MISSING_DATA && y~=el.MISSING_DATA && sample.pa(eyeUsed+1)>0
        gazeX = [gazeX x];
        gazeY = [gazeY y];
    end
end
    if exist('win','var')
        trace = 20; % length of samples that we will use for drawing
        if length(gazeX) > trace
        Screen('DrawDots',win,[gazeX(end-trace:end)+corrX;gazeY(end-trace:end)+corrY],2,[200 0 0]); 
        elseif length(gazeX) > 1
        Screen('DrawDots',win,[gazeX+corrX;gazeY+corrY],2,[200 0 0]); 
        end
        %Screen('Flip',win);
    end
end

