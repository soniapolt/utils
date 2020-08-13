function e = niceBoxplotGrouped(data,ROIs,conds,plotMed,dotColors,cutY,plotData)
% colors needs to be in n-by-3 matrix
% plotMed will label the medians
% cutY sets a ylimit
% version 2 is manuscript coloring

colors = repmat([lighter(black,30);lighter(black,70)],size(data,2),1);
dotColors = flipud(dotColors);

if ~exist('plotData','var') plotData = 0; end

b= boxplot(data,{Expand(ROIs,length(conds),1),repmat(conds,1,length(ROIs))},'colors',colors,'factorgap',[50 0],'labelverbosity','minor',...
    'boxstyle','outline','medianstyle','line','outliersize',.5,'jitter',.1,'widths',.5);%,'ColorGroup',colors);
c = findobj(gca,'tag','Median'); d = findobj(gca,'tag','Box');
e = findobj(gca,'tag','Upper Whisker'); f = findobj(gca,'tag','Lower Whisker'); 

% fringe case where we're plotting two hems on the same axis
if length(c) == 2*length(colors)
    colors = [colors; colors]; end

% non-filled bars
for x = 1:length(c) 
    set(d(x),'Color','w','LineWidth',.01);
    patch(get(d(x),'XData'),get(d(x),'YData'),colors(x,:),'LineStyle','none');
    set(c(x),'Color','w','LineWidth',.5);
    % median on top plz
    uistack(c(x),'top');
    set(e(x),'LineStyle','-','Color',colors(x,:),'LineWidth',.2); 
    set(f(x),'LineStyle','-','Color',colors(x,:),'LineWidth',.2); 
end


delete(findobj(gca,'Tag','Upper Adjacent Value'));delete(findobj(gca,'Tag','Lower Adjacent Value'));

% filled light/dark grey bars
% for x = 1:length(c) 
%     set(d(x),'LineStyle','none'); 
%     patch(get(d(x),'XData'),get(d(x),'YData'),colors(x,:),'FaceAlpha',1,'LineStyle','none');
%     set(c(x),'Color',black);
%     set(e(x),'LineStyle','-','Color',black,'LineWidth',.2); 
%     set(f(x),'LineStyle','-','Color',black,'LineWidth',.2); 
% end

% to line up our dots with our bars
pos = [e.XData]; pos = fliplr(pos(1:2:end))
gap = pos(3)-pos(1); offset = .33*gap; jitter = .15*(pos(2)-pos(1));

if plotData 
    for n = 1:size(data,2)
        rj = (pos(n)-offset)*ones(size(data,1),1) + (-jitter + (2*jitter)*rand(size(data,1),1));
   hold on; plot(rj,data(:,n),'linestyle','none','marker','.','markersize',5,'color',lighter(dotColors(n,:),90));
   hold on; plot(rj,data(:,n),'linestyle','none','marker','.','markersize',3,'color',dotColors(n,:));
   
   %scatter(Expand(pos,size(data,1),1)',reshape(data,[],1),3,flipud(Expand(dotColors,1,size(data,1))),'filled','markeredgecolor','k','linewidth',.1)
end
end
h = findobj(gca,'tag','Outliers');
set(h,'MarkerEdgeColor',[.5 .5 .5]);

if exist('cutY','var') && ~isempty(cutY)
    ylim([cutY]); end

xl = get(gca,'xlim');yl = get(gca,'ylim');
set(gca,'box','off','tickdir','out','color','none','xlim',[-.5*gap xl(2)],'xtick',[]);

if yl(1) < 0 hline(0,'k'); end

if exist('plotMed','var') && plotMed
    m = findobj(gca,'tag','Median');
    m= flipud(m);
    for s = 1:length(labels)
        med = get(m(s),'YData');
        txt = [labels{s} ' = ' num2str(med(1))];
        yl = ylim;
        t = text(s+.1,yl(1)+(yl(2)*.1*s),txt); set(t,'Color','k','FontSize',12);
    end
end

end

