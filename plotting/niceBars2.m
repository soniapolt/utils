function [hbar] = niceBars2(data,whichM,whichIndiv,xlab,color)
% function [hbar] = niceBars2(data,whichM,whichIndiv,xlab,color)
% unlike niceBars, which takes one mean & se value per condition, this lets
% us work with the raw data itself & plot individual subject points, etc
% wants a color for every bar
% whichIndiv = 0: do not plot individual subject data
% whichInidv = 1: plot individual subjects as dots (no linking across bars)
% whichIndiv = 2: plot individual subjects as lines across bars

nBars = size(data,2);% columns == bars
if ~exist('color','var'); color = condColors(1:nBars,1); end % each bar is a different color by default
subjCol = repmat(linspace(0.2,1,size(data,1)),3,1)'; % shade each subject the same across plots

% bars themselves
for n = 1:nBars 
eval(['m(n) = nan' whichM '(data(:,n));']);
hbar = bar(n,m(n),.4); hold on;
set(hbar,'facecolor',color(n,:),'edgecolor','none'); 

% indiv subjects version 1
if whichIndiv == 1 scatter(repmat(n,1,size(data,1)),data(:,n),30,subjCol,'filled'); hold on; end
% like version 1 but toned down for manuscript figures
if whichIndiv == 3 scatter(repmat(n,1,size(data,1)),data(:,n),6,subjCol,'filled'); hold on; end

end


% indiv subjects version 2
if whichIndiv == 2
   p = plot(1:nBars,data,'linewidth',2); hold on;%,'marker','o');
   set(p,{'color'},num2cell(subjCol,2));
end 

% error bars
for n = 1:nBars
h = errorbar(n, m(n),se(data(:,n)),'color',color(n,:)*.5,'linestyle', 'none'); hold on;
set(h,'linewidth',.5);  
if ~verLessThan('matlab','9.4') h.CapSize = 0; end % remove horizontal ticks on errorbars   

if exist('xlab','var') && ~isempty(xlab) % since xticklabels are stupid with this kind of plotting
    if isnumeric(xlab{n}) xlab{n} = num2str(xlab{n}); end
    text(n+.1,m(n)+.5, xlab{n}); hold on; end
end

set(gca,'box','off','tickdir','out');
end