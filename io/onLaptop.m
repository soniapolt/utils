function [lap] = onLaptop
% uses screen size to infer if we're on a laptop or on the giant lab
% desktop monitor. useful for plotting figures.
% also checks to see if you're connected to an external monitor of any kind

if isdir('/share/kalanit') lap = 0; else lap = 1; end

% scr = get(0,'screensize');
% if scr(3)<1793
%     lap = 1;
% else lap = 0;
% end
% 
% try
% if length(Screen('Screens')) > 1 lap = 0; end
% catch warning(sprintf('Missing PTB...\n')); end
% end

