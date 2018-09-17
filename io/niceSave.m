function niceSave(figDir,fName,ROIs,subjs,formats)
% saves a few versions of the current figure
% default is png
if ~exist('formats','var')
    formats= {'png'}; end

% does the figure directory exist?
checkDir(figDir);

% do we want to specify something about the data that we're plotting?
addText = [];
if exist('ROIs','var') && ~isempty(ROIs)
    if length(ROIs)==1
        addText = ROIs{1};
    elseif length(ROIs)>4
        addText = 'all';
    elseif ~isempty(strfind(ROIs{end},'faces'))
        addText = 'faceROIs';
    else addText = 'EVC'; end
end

if exist('subjs','var') && ~isempty(subjs)
    addText = [addText '_' horzcat(subjs{:})]; end

% don't do any weird rescaling
set(gcf, 'PaperPositionMode', 'auto');

% save all our formats
for n = 1:length(formats)
    
    fprintf(['Saving to: ' [figDir fName addText '.' formats{n}] '...\n']);
    saveas(gcf,[figDir fName addText '.' formats{n}],formats{n});
    % and say so
    
end

