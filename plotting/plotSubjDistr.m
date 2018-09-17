function plotSubjDistr(subjData,whichPlot,legText,nBins)
% plots a distribution of some value (like XY shift) over subjects, keeping
% subject data separate but on the same scale
% subjData{s} is a cell containting the data to be plotted
% whichPlot: 1 = plot subjects, 2 = plot mean, 3 = plot both

% clx;
% whichPlot = 3;legText = {'S1' 'S2' 'S3'};
%
% for s = 1:3
% subjData{s} = rand(1,500);
% end

if ~exist('nBins','var') nBins = 100; end

edges = linspace(min([subjData{:}]),max([subjData{:}]),nBins);

for s = 1:length(subjData)
    counts(s,:) =  histc(subjData{s},edges);
end

if whichPlot == 1 || whichPlot ==3
    hold on; pl = plot(edges,counts);
    yl = ylim;
    for s = 1:length(subjData)
        color = condColors(s+3,1);
        set(pl(s),'color',color,'LineWidth',2.5);
        vv = vline(nanmean(subjData{s}),'k:'); set(vv,'Color',color,'LineWidth',1);
        txt = ['  ' legText{s} ' = ' num2str(nanmean(subjData{s}))];
        t = text(nanmean(subjData{s}),yl(2)-(yl(2)*.15*s),txt); set(t,'Color',color,'FontSize',12);
        %     vv = vline(nanmean(subjData{s}),'k:',num2str(nanmean(subjData{s}))); set(vv,'Color',color,'LineWidth',2);
    end
end


if (whichPlot == 2 || whichPlot ==3) && length(subjData)>1
    color = condColors(randi(7),1);
    hold on; shadedErrorBar(edges,mean(counts),std(counts)/sqrt(length(subjData)),color);
    hold on; vv = vline(nanmean([subjData{:}]),'k:'); set(vv,'Color',color,'LineWidth',2);
    yl = ylim;
    % plot overall average value
    
    txt = ['  Mean = ' num2str(nanmean([subjData{:}]))];
    t = text(nanmean([subjData{:}]),yl(2)*.75,txt); set(t,'Color',color,'FontSize',12);
end

hold on; vline(0,'k'); % zero line
set(gca,'box','off'); ylim([0 max(counts(:))]);%axis square;
ylabel('Voxel Count');

% if ~isempty(legText) && whichPlot ~=2
%     legend(legText,'location','Best','FontSize',12,'box','off','color','none');
% end

%end

