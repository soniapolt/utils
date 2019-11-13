function string = strTogether(cellArray,numSpaces,delim)
% strings together the elements of a cell array of strings, with a
% specified number of space separators

if ~exist('numSpaces','var')
    numSpaces = 1;
end

string = [];
for n = 1:length(cellArray)-1
    if ~exist('delim','var')
    string = [string cellArray{n} spaces(numSpaces)];
    else string = [string cellArray{n} delim];
    end
end
string = [string cellArray{end}];

end

