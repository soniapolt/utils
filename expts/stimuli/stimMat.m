function stimMat(imDir,matName,fileType,matDir)
% makes .mat file from a specific image set (e.g. our internal features
% faces)
% implementation: stimMat('/share/kalanit/biac2/kgs/projects/invPRF/images/external','external.mat')

%imDir = '/share/kalanit/biac2/kgs/projects/invPRF/images/external/';
%matName = 'external.mat';
if ~exist('matDir','var') matDir = pwd; end % default save to the working directory
if ~exist('fileType','var') fileType = 'png'; end % currently we're working with faces

fileNames = cleanFileNames(imDir,fileType);

face = [];
for n = 1:length(fileNames)
    try
        face{n} = rgb2gray(imread([imDir '/' fileNames{n}],fileType));
        fprintf('face%d converted 2 gray!\n',n);
    catch
        face{n} = imread([imDir '/' fileNames{n}],fileType);
        fprintf('face%d...\n',n);
    end
end

fprintf('Saving %d faceIms to %s!\n',n,[matDir '/' matName]);

save([matDir '/' matName],'face');
