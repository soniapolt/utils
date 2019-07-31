function f = niceFig(figSize,fontSize,painters)
% initialized figure with some nicer params
if ~exist('figSize','var') figSize = [.1 .1 .8 .8]; end
if ~exist('fontSize','var') fontSize = 12; end

f= figure;set(gcf,'color',[1 1 1],'Units', 'Normalized', 'OuterPosition', figSize,'DefaultTextFontSize',fontSize);

if exist('painters','var')
    set(gcf,'renderer','Painters');
else
    set(gcf,'renderer','OpenGL');
end

end

