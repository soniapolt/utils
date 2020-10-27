function [subjs] = compSubjs(n)
% function [subjs] = compSubjs
% outputs a cell of all subject initials in the compPRF experiment
subjs = {'DF' 'EM' 'JG' 'MG' 'SP' 'TH'};
if exist('n','var')
    subjs = subjs(n); 
end
end

