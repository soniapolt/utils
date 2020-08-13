function e = niceBoxPlusGrouped(data,ROIs,conds,dotColors,cutY,plotData,offsetData)
% individual subject data (like in niceBoxPlotGrouped) but without the
% boxplot, instead replacing with a dot & errorbar for the mean +/- SE
% assumes data grouping like in niceBoxPlotGrouped, eg. V1-upr, V1-inv,
% V2-upr, V2-inv and so on

if length(conds) == 1
    colors = repmat([lighter(black,30)],length(ROIs),1);
else
colors = repmat([lighter(black,70);lighter(black,30)],length(ROIs),1);
end

if ~exist('plotData','var') plotData = 0; end
if ~exist('offsetData','var') offsetData = 0; end

% xaxis of mean/se plot
xSpace = [0]; gap =2;
for r = 1:length(ROIs) % big jump
    xSpace(end+1) = xSpace(end)+gap;
for c = 1:length(conds)-1 % lil jump
    xSpace(end+1) = xSpace(end)+gap/3;
end
end
xSpace = xSpace(2:end); % remove leading zero

if offsetData == 1
%xaxis of indiv data plot (if overlapping set equal to xSpace
offset = gap/8; min = 0;
else offset = 0; min = 0.5; end
jitter = .15*(gap/4);

scatterErr(xSpace,nanmean(data,1)',se(data)',colors,30);hold on;

if plotData 
    for n = 1:size(data,2)
        rj = (xSpace(n)-offset)*ones(size(data,1),1) + (-jitter + (2*jitter)*rand(size(data,1),1));
   hold on; plot(rj,data(:,n),'linestyle','none','marker','.','markersize',6,'color',lighter(dotColors(n,:),80));
   hold on; plot(rj,data(:,n),'linestyle','none','marker','.','markersize',4,'color',dotColors(n,:));
   
   %scatter(Expand(pos,size(data,1),1)',reshape(data,[],1),3,flipud(Expand(dotColors,1,size(data,1))),'filled','markeredgecolor','k','linewidth',.1)
end
end

if exist('cutY','var') && ~isempty(cutY)
    ylim([cutY]); end

xl = get(gca,'xlim');yl = get(gca,'ylim');
set(gca,'box','off','tickdir','out','color','none','xlim',[min xl(2)],'xtick',[]);

if yl(1) < 0 hline(0,'k'); end

end

