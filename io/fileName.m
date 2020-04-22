function [file,pathN] = fileName(path,nChars)
% [file,pathN] = fileName(path,nChars)
% simple(r) return of filename from path

[pathN,file] = fileparts(path);

if exist('nChars','var')
    file = file(1:nChars); end

end

