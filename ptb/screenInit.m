function [win, rect] = screenInit(color,textSize,blend)
% initialize screen with some defaults
if ~exist('textSize','var') textSize = 18; end
if ~exist('color','var') color = [128 128 128]; end   
if ~exist('blend','var') blend = 1; end   % 1 = allows use of alpha channel
  
[win, rect]=Screen('OpenWindow',max(Screen('Screens')),color);
Screen(win, 'TextSize', textSize); 
if blend Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); end

end

