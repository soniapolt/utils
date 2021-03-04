function [viewText] = viewText(viewnum)
%function [viewText] = viewText(viewnum)
% interpreting cvn lookup view nums for filenames etc
if viewnum == 3; viewText = 'inflatedVTC';
elseif viewnum == 16 viewText = 'flatVTC';
else viewText = ['view' num2str(viewnum)]; end
end

