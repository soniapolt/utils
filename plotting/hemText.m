function [string] = hemText(hems)
%U either prints the hemisphere name or bilat if there's two of them
if length(hems)>1
        string = 'bilat';
    else string = hems{1}; end
end

