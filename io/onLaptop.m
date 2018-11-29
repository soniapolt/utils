function [lap] = onLaptop
% uses screen size to infer if we're on a laptop or on the giant lab
% desktop monitor. useful for plotting figures.

scr = get(0,'screensize');
if scr(3)<1441
    lap = 1;
else lap = 0;
end

end

