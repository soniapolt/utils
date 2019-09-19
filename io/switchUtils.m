function switchUtils
% function switchUtils
% removes path to remote utils, adds path to local utils - can help speed
% things up if you're working remotely
rmpath(genpath('/Volumes/projects/sonia/utils'));
addpath(genpath('/Users/sonia/matlab/utils'));
end

