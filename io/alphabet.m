function [str] = alphabet(n,upperCase)
% returns the whole alphabet, or some portion of it

if ~exist('n','var') || isempty(n) 
    n = 1:26; end

n(n>26) = []; % clip any values beyond 26

alphabet = ['a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m';'n';'o';'p';'q';'r';'s';'t';'u';'v';'w';'x';'y';'z'];
str = alphabet(n);

if exist('upperCase','var')
   str = upper(str); end

%end

