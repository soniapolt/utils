function [samples] = eyeInSpace(tr,eyeInit,rate,dva,centerCrop,markPoint,noTime)
% input:
% - tr (trial) variable with fields: start, text, cond, samples, fixations,
% saccades, and blinks. generated in ascParse.m
% - dva: binary whether or not to convert data to degree of visual angle.
% if so, we also need info about the screen & distances in eyeInit
% - centerCrop: optionally plot only the center X degrees of the image (we likely aren't
% using all of the screen real estate)
% - markPoint: optionally mark an arbitrary point in stim space (e.g.
% corresponding to a stim presentation location);
% - noTime: binary telling us to ignore the time dimension (useful for
% collapsing across trials, for example)

%centerCrop = 5; tr = trial(1); markPoint = [-1 1]; dva = 1;
if ~exist('eyeInit.mmScreen','var') eyeInit.mmScreen = [385.28 288.96]; end
if ~exist('noTime','var') noTime = 0; end

% recenter to zero
plotLim = [-eyeInit.screen.width/2 eyeInit.screen.width/2; -eyeInit.screen.height/2 eyeInit.screen.height/2]; 
tr.samples(:,2:3) = tr.samples(:,2:3)-repmat([plotLim(1,2) plotLim(2,2)],length(tr.samples),1);

% set time to zero
nativeTime = tr.samples(:,1); % for indexing later
tr.samples(:,1) = (tr.samples(:,1)-tr.samples(1,1))/rate;

if dva [plotLim,ppd] = pix2deg(plotLim,eyeInit.screen.width,eyeInit.mmScreen(1)/100,eyeInit.screenDist/100); 
    tr.samples(:,2:3) = tr.samples(:,2:3)./ppd;
end

% make plot
set(gca,'YDir','reverse');
if noTime plot(tr.samples(:,2),tr.samples(:,3),'Color',condColors(3)); 
else 
surface([tr.samples(:,2),tr.samples(:,2)],[tr.samples(:,3),tr.samples(:,3),],[tr.samples(:,1),...
    tr.samples(:,1)],'EdgeColor','flat', 'FaceColor','none','EdgeAlpha',.1,'LineWidth',2); 
% make colorbar
colormap(summer);
time = 0:2:round(tr.samples(end,1));
matVer = version;
if str2num(matVer(end-2)) >5 
    cbar = colorbar('Ticks',time); cbar.Label.String= 'Time (seconds)';
else cbar = colorbar('YTick',time); ylabel(cbar,'Time (seconds)')
end

end

% mark fixations
for n = 1:size(tr.fixations,1)
    ind = find(nativeTime==tr.fixations(n,1)):find(nativeTime==tr.fixations(n,2));
    hold on; p{1}= plot(tr.samples(ind,2),tr.samples(ind,3),'k:','LineWidth',1.5);
end

% mark blinks and fixations
for n = 1:size(tr.blinks,1)
    ind = find(nativeTime==tr.blinks(n,1)):find(nativeTime==tr.blinks(n,2));
    hold on; p{2}=plot(tr.samples(ind,2),tr.samples(ind,3),'o','MarkerSize',3,'Color',condColors(5));
end

% set axes
if exist('centerCrop','var') plotLim = [-centerCrop centerCrop; -centerCrop centerCrop]; axis square; end
xlim(plotLim(1,:)); ylim(plotLim(2,:));

% mark center
hold on; hline(0,'k'); vline(0,'k'); 
xticks(plotLim(1,1):plotLim(1,2)); yticks(plotLim(2,1):plotLim(2,2)); grid on;

% mark point, as specified by user
if exist('markPoint','var') 
    for n = 1:size(markPoint,1)
        hold on; plot(markPoint(n,1),markPoint(n,2),'ko'); end
end

% set legend (after we've adjusted axes etc.)
if size(tr.blinks,1)>1
l = legend([p{1} p{2}],{'Fixations','Blinks'}); 
else l = legend(p{1},{'Fixations'}); end
set(l,'FontSize',8,'box','off');

samples = tr.samples; % to return