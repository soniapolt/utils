function f = niceFig(figSize,fontSize,painters)
% initialized figure with some nicer params
f= figure;set(gcf,'color',[1 1 1],'Units', 'Normalized', 'OuterPosition', figSize,'DefaultTextFontSize',fontSize);

if exist('painters','var')
    set(gcf,'renderer','Painters');
else
    set(gcf,'renderer','OpenGL');
end

end

