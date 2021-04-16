function f = niceFig(figSize,fontSize,painters)
% initialized figure with some nicer params
if ~exist('figSize','var') figSize = [.1 .1 .8 .8]; end
if ~exist('fontSize','var') fontSize = 12; end

if ~isnumeric(figSize)
    switch figSize
        case 'square'
            figSize = [.1 .1 .5 .8];
        case 'wide'
            figSize = [.1 .1 .8 .4];
        case 'tall'
            figSize = [.1 .1 .3 .9];
    end
end

f= figure;set(gcf,'color',[1 1 1],'Units', 'Normalized', 'OuterPosition', figSize,'DefaultTextFontSize',fontSize);

if exist('painters','var')
    set(gcf,'renderer','Painters');
else
    set(gcf,'renderer','OpenGL');
end

end

