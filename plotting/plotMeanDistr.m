
function [h,peak,counts] =  plotMeanDistr(cData,nBins,color)
% function plotMeanDistr(cData,nBins,color,whichM)
% data is in form pars{s,c} so we preserve the distribution for each
% subject
% plots a distribution of some value (like XY shift) over subjects,
% normalizing within subjects (so we're plotting proportion of voxels and
% not voxel count) and then averaging those distributions

%cData = sPars(:,c);

if ~exist('nBins','var') nBins = 100; end
if ~exist('whichM','var') whichM = 3; end

edges = linspace(min(min([cData{:}])),max(max([cData{:}])),nBins);
for s = 1:length(cData)
    [counts(s,:),bin{s}] =  histc(cData{s},edges);
    % normalize within subjects
    counts(s,:) = counts(s,:)./sum(counts(s,:));
end

mcount = nanmean(counts);
peak = edges(find(mcount == nanmax(mcount)));
h = shadedErrorBar(edges,mcount,se(counts),color); hold on;


hold on; vv = vline(peak,'k:'); set(vv,'Color',color,'LineWidth',2);
yl = ylim;
% 
txt = ['Peak = ' num2str(peak)];
t = text(peak,yl(2)*.75,txt); set(t,'Color',color,'FontSize',12);

hold on; vline(0,'k'); % zero line
set(gca,'box','off'); axis square;% 
ylabel('Voxel Proportion');


% if ~isempty(legText) && whichPlot ~=2
%     legend(legText,'location','Best','FontSize',12,'box','off','color','none');
% end

%end

