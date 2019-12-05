function [mu, ci] =  niceHistFit(data,color,numBins,plotMu)
% well-colored histogram plot with option to plot a line at its median;
% default plots a line at 0

if ~exist('numBins','var') numBins = 100; end

hold on; histfit(data,numBins); axis square;
h = findobj(gca,'Type','patch');
set(h,'FaceColor',color,'FaceAlpha',.5,'EdgeAlpha',0);
set(gca,'box','off','color','none');

if ~iscolumn(data); data = data'; end

pd = fitdist(data,'Normal');
mu = pd.mu; ci =  paramci(pd); ci = ci(:,1);
                
if exist('plotMu','var')
vv = vline(mu,'k:',['Mu = ' num2str(mu)]); set(vv,'Color',color,'LineWidth',2);
vv = vline(ci(1),'k:'); set(vv,'Color',color,'LineWidth',.5);
vv = vline(ci(2),'k:'); set(vv,'Color',color,'LineWidth',.5);
end
v = vline(0,'k'); set(v,'LineWidth',2);

end

