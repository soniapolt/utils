function [win,rect] = eyelinkDriftCorrect(prompt,el,win,xc,yc,fixRad,color)
% wrapper function to run drift correction on eyelink tracker
% restarts the screen when done

if ~exist('fixRad','var'); fixRad = 10; end
if ~exist('color','var'); color = [127 127 127]; end

if prompt
    %%% prompt drift correction
    DrawFormattedText(win,['Eyetracking drift correction - fixate on the central dot.']...
        ,'center', 'center',[0 0 0]);
    Screen(win, 'Flip', 0); WaitSecs(3);
end

% 
bullseyeFix(win,xc, yc, fixRad, 2, [0 0 200], 1);
Screen('Flip',win);
Eyelink('Command','online_dcorr_maxangle = 1000');

success = EyelinkDoDriftCorrection(el, [], [], 0, 1);
if ~success fprintf('Eyelink DriftCorrection failed!'); end
[win,rect] = screenInit(color,18,1);
end

