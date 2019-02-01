function plotSubjDistr(subjData,whichPlot,legText,nBins,whichM,doT)
% plots a distribution of some value (like XY shift) over subjects, keeping
% subject data separate but on the same scale
% subjData{s} is a cell containting the data to be plotted
% whichPlot: 1 = plot subjects/conds, 2 = plot mean, 3 = plot both
% whichM: summarize via 1) mean 2) mode 3) median
% clx;

% whichPlot = 1;legText = {'S1' 'S2' 'S3'};doT = 1;
% 
% for s = 1:3
% subjData{s} = rand(1,500);
% end

if ~exist('nBins','var') nBins = 100; end
if ~exist('whichM','var') whichM = 1; end
if ~exist('doT','var') doT = 0; end

edges = linspace(min([subjData{:}]),max([subjData{:}]),nBins);

for s = 1:length(subjData)
    [counts(s,:),bin(s,:)] =  histc(subjData{s},edges);
end

if whichPlot == 1 || whichPlot ==3
    hold on; pl = plot(edges,counts);
    yl = ylim;
    for s = 1:length(subjData)
        color = condColors(s+3,1);
        set(pl(s),'color',color,'LineWidth',2.5);
        
        if whichM == 1 % mean
            val = nanmean([subjData{s}]); na = 'Mean';
        elseif whichM == 2
            val = edges(mode(bin(s,:))); na = 'Peak';
        elseif whichM == 3
            val = nanmedian([subjData{s}]); na = 'Median';
        end
        vv = vline(val,'k:'); set(vv,'Color',color,'LineWidth',1);
        txt = ['  ' legText{s} ' (' na ') = ' num2str(val)];
        t = text(val,yl(2)-(yl(2)*.15*s),txt); set(t,'Color',color,'FontSize',12);
    end
end


if (whichPlot == 2 || whichPlot ==3) && length(subjData)>1
    color = condColors(randi(7),1);
    hold on; shadedErrorBar(edges,mean(counts),std(counts)/sqrt(length(subjData)),color);
    
    if whichM == 1 % mean
        val = nanmean([subjData{:}]); na = 'Mean';
    elseif whichM == 2
        val = 0;%max([subjData{:}]); 
        na = 'Mode';
    elseif whichM == 3
        val = nanmedian([subjData{:}]); na = 'Median';
    end
    
    hold on; vv = vline(nanmean([subjData{:}]),'k:'); set(vv,'Color',color,'LineWidth',2);
    yl = ylim;
    
    txt = ['  ' na ' = ' num2str(val)];
    t = text(val,yl(2)*.75,txt); set(t,'Color',color,'FontSize',12);
end

hold on; vline(0,'k'); % zero line
set(gca,'box','off'); ylim([0 max(counts(:))]);%axis square;
ylabel('Voxel Count');

% if exist('doT','var')&& doT>0
%    combos =  nchoosek([1:length(condData)],2);
%    for c = 1:size(combos,1)
%    [H,P,KSSTAT] = kstest2(nanmean(subjData{combos(c,1)}),condData{combos(c,2)}); 
%    ttxt{c} = [condNames{combos(c,1)} ' v. ' condNames{combos(c,2)} ': ksstat= ' num2str(KSSTAT) ', p=' num2str(P)];
%    end
%    title(ttxt);
% end
% if ~isempty(legText) && whichPlot ~=2
%     legend(legText,'location','Best','FontSize',12,'box','off','color','none');
% end

%end

