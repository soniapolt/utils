function niceGCA(fontSize)
if ~exist('fontSize','var') fontSize = 16; end
set(gca,'box','off','FontSize',fontSize,'FontName','Arial','FontWeight','normal','TickDir','out');
end

