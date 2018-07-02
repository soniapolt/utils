function string = strTogether(cellArray,numSpaces)
% strings together the elements of a cell array of strings, with a
% specified number of space separators

if ~exist('numSpaces','var')
    numSpaces = 1;
end

string = [];
for n = 1:length(cellArray)-1
    string = [string cellArray{n} spaces(numSpaces)];
end
string = [string cellArray{end}];

end

