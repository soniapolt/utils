function softLink(out,in)
% makes a softlink; defaults to linking the current directory t oan input
% directory
if ~exist('in','var')
   in = pwd;
end
system(['ln -s ' in ' ' out]);
end

