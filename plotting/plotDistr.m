function plotDistr(condData,whichPlot,condNames,nBins,whichM,doKS,dark)
% plots a distribution of some value (like XY shift) over subjects, keeping
% subject data separate but on the same scale
% subjData{s} is a cell containting the data to be plotted
% whichPlot: 1 = plot subjects/conds, 2 = plot mean, 3 = plot both
% whichM: summarize via 1) mean 2) mode 3) median
% clx;
%whichPlot = 3;condNames = {'S1' 'S2' 'S3'}; doKS = 1;

% for s = 1:3
% condData{s} = rand(1,500);
% end

if ~exist('nBins','var') nBins = 100; end
if ~exist('whichM','var') whichM = 3; end

edges = linspace(min(min([condData{:}])),max(max([condData{:}])),nBins);

for s = 1:length(condData)
    [counts(s,:),bin{s}] =  histc(condData{s},edges);
end

if whichPlot == 1 || whichPlot ==3
    hold on; pl = plot(edges,counts);
    yl = ylim;
    for s = 1:length(condData)
        color = condColors(s+3,1);
        if dark color = darker(color); end
        set(pl(s),'color',color,'LineWidth',2.5);
        
        if whichM == 1 % mean
            val = nanmean([condData{s}]); na = 'Mean';
        elseif whichM == 2
            val = edges(mode(bin{s})); na = 'Peak';
        elseif whichM == 3
            val = nanmedian([condData{s}]); na = 'Median';
        end
        vv = vline(val,'k:'); set(vv,'Color',color,'LineWidth',1);
        txt = ['  ' condNames{s} ' (' na ') = ' num2str(val)];
        t = text(val,yl(2)-(yl(2)*.15*s),txt); set(t,'Color',color,'FontSize',12);
    end
end


if (whichPlot == 2 || whichPlot ==3) && length(condData)>1
    color = condColors(randi(7),1);
    hold on; shadedErrorBar(edges,mean(counts),std(counts)/sqrt(length(condData)),color);
    
    if whichM == 1 % mean
        val = nanmean([condData{:}]); na = 'Mean';
    elseif whichM == 2
        val = 0;%max([subjData{:}]); 
        na = 'Mode';
    elseif whichM == 3
        val = nanmedian([condData{:}]); na = 'Median';
    end
    
    hold on; vv = vline(nanmean([condData{:}]),'k:'); set(vv,'Color',color,'LineWidth',2);
    yl = ylim;
    
    txt = ['  ' na ' = ' num2str(val)];
    t = text(val,yl(2)*.75,txt); set(t,'Color',color,'FontSize',12);
end

hold on; vline(0,'k'); % zero line
set(gca,'box','off'); ylim([0 max(counts(:))]);%axis square;
ylabel('Voxel Count');

if exist('doKS','var')&& doKS>0
   combos =  nchoosek([1:length(condData)],2);
   for c = 1:size(combos,1)
   [H,P,KSSTAT] = kstest2(condData{combos(c,1)},condData{combos(c,2)}); 
   ttxt{c} = [condNames{combos(c,1)} ' v. ' condNames{combos(c,2)} ': ksstat= ' num2str(KSSTAT) ', p=' num2str(P)];
   end
   title(ttxt);
end

% if ~isempty(legText) && whichPlot ~=2
%     legend(legText,'location','Best','FontSize',12,'box','off','color','none');
% end

%end

