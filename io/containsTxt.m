function [r] = containsTxt(longStr, findStr)
% string comparison 
if ~isempty(strfind(longStr,findStr))
 r = 1;
else r = 0;
end

end

