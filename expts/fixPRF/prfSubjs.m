function [subjs] = prfSubjs(n)
% function [subjs] = prfSubjs
% outputs a cell of all subject initials in the fixPRF experiment
subjs = {'TH' 'SP' 'JJ' 'JG' 'MH' 'MG' 'MN' 'JP' 'JW' 'EM' 'DF' 'MZ'};
if exist('n','var')
    subjs = subjs(1:n); 
end
end

