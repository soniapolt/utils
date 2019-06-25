function bullseyeFix(xc, yc, fixRad, outerPixels, dotColor, alpha)
% bullseye-style fixation point - ptb dependent
if ~exist('alpha','var') alpha = 1; end

Screen('FillOval', win,[0 0 0 255*alpha], [xc-fixRad yc-fixRad xc+fixRad yc+fixRad]); % outer fixation ring
Screen('FillOval', win,[255 255 255 255*alpha], [xc-fixRad+outerPixels yc-fixRad+outerPixels xc+fixRad-outerPixels yc+fixRad-outerPixels]); % white fixation disk
Screen('FillOval', win,dotColor, [xc-3 yc-3 xc+3 yc+3]); % little fixation dot
end

