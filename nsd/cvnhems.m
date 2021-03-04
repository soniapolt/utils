function hems = cvnhems(ind)
% returns hems = {'lh' 'rh'}, so we keep consistency for generating angle
% maps etc
hems = {'lh' 'rh'};
if exist('ind','var') hems = hems{ind}; end
end

