function [external, laptop] = deviceNums
%clear PsychHID; clear KbCheck; % just in case
[keyboardIndices, productNames, ~] = GetKeyboardIndices;
external = keyboardIndices(1);
if numel(keyboardIndices) == 1
    laptop = keyboardIndices(1); % don't differentiate external/laptop if no external keyboard is connected
else laptop = keyboardIndices(2); end
end

