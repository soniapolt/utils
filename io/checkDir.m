function [madeIt] = checkDir(dir)
% checks to see if directory exists, and if it doesn't creates it
if ~exist(dir)
    mkdir(dir);
    madeIt = 1;
else madeIt = 0; end
end