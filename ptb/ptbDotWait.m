function ptbDotWait(win,numSecs)
% draws a dot countdown to the screen to ready the subject for the task
for n = 1:numSecs
DrawFormattedText(win,strTogether({repmat('.',1,n)}), 'center', 'center'); Screen(win, 'Flip', 0);
WaitSecs(1);
end

