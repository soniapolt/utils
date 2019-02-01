function f = niceFig(figSize,fontSize)
% initialized figure with some nicer params
f= figure;set(gcf,'color',[1 1 1],'Units', 'Normalized', 'OuterPosition', figSize,'DefaultTextFontSize',fontSize);
set(gcf,'renderer','Painters');
end

