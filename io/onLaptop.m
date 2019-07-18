function [lap] = onLaptop
% uses screen size to infer if we're on a laptop or on the giant lab
% desktop monitor. useful for plotting figures.
% also checks to see if you're connected to an external monitor of any kind

scr = get(0,'screensize');
if scr(3)<1441
    lap = 1;
else lap = 0;
end

if length(Screen('Screens')) > 1 lap = 0; end
end

