
function [h,meds,counts] =  plotMeanDistr(cData,nBins,color,plotSummary)
% function plotMeanDistr(cData,nBins,color)
% data is in form pars{s,c} so we preserve the distribution for each
% subject
% plots a distribution of some value (like XY shift) over subjects,
% normalizing within subjects (so we're plotting proportion of voxels and
% not voxel count) and then averaging those distributions

%cData = sPars(:,c);
if ~exist('plotSummary','var') plotSummary = 0; end
if ~exist('nBins','var') nBins = 100; end

edges = linspace(min(min([cData{:}])),max(max([cData{:}])),nBins);
for s = 1:length(cData)
    [counts(s,:),bin{s}] =  histc(cData{s},edges);
    % normalize within subjects
    counts(s,:) = counts(s,:)./sum(counts(s,:));
    meds(s) = nanmedian(cData{s});
end

mcount = nanmean(counts);
% peak = edges(find(mcount == nanmax(mcount)));
summary = nanmean(meds); whichSummary = 'Median Avg.';
h = shadedErrorBar(edges,mcount,se(counts),color); hold on;
yl = ylim;

if plotSummary
hold on; vv = vline(summary,'k'); set(vv,'Color',color,'LineWidth',1);
hold on; v = vline(summary+se(meds),'k:'); set(v,'Color',color,'LineWidth',.5);
hold on; v = vline(summary-se(meds),'k:'); set(v,'Color',color,'LineWidth',.5);


% 
txt = [whichSummary ' = ' num2str(summary)];
t = text(summary,yl(2)*.75,txt); set(t,'Color',color,'FontSize',12);
end

hold on; vline(0,'k'); % zero line
set(gca,'box','off'); axis square;% 
ylabel('Voxel Proportion');


% if ~isempty(legText) && whichPlot ~=2
%     legend(legText,'location','Best','FontSize',12,'box','off','color','none');
% end

%end

