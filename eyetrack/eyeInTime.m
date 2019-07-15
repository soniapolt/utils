function eyeInTime(tr,eyeInit,rate,dva,centerCrop)
% input:
% - tr (trial) variable with fields: start, text, cond, samples, fixations,
% saccades, and blinks. generated in ascParse.m
% - dva: binary whether or not to convert data to degree of visual angle.
% if so, we also need info about the screen & distances in eyeInit
% - centerCrop: optionally plot only the center X degrees of the image (we likely aren't
% using all of the screen real estate)
% - markPoint: optionally 

%centerCrop = 5; tr = trial(1); markPoint = [-1 1]; dva = 1; rate = 1000;
if ~exist('eyeInit.mmScreen','var') eyeInit.mmScreen = [385.28 288.96]; end

% recenter to zero
plotLim = [-eyeInit.screen.width/2 eyeInit.screen.width/2; -eyeInit.screen.height/2 eyeInit.screen.height/2]; 
tr.samples(:,2:3) = tr.samples(:,2:3)-repmat([plotLim(1,2) plotLim(2,2)],length(tr.samples),1);

% set time to zero
nativeTime = tr.samples(:,1); % for indexing later
tr.samples(:,1) = (tr.samples(:,1)-tr.samples(1,1))/rate;

% convert to DVA
if dva [plotLim,ppd] = pix2deg(plotLim,eyeInit.screen.width,eyeInit.mmScreen(1)/100,eyeInit.screenDist/100); 
    tr.samples(:,2:3) = tr.samples(:,2:3)./ppd;
end

plotText = {'X position ' 'Y position '}; if dva strcat(plotText,'(dva)'); else strcat(plotText,'(pix)'); end

for p = 1:2
% make plot
set(gca,'YDir','reverse'); subplot(1,2,p);
plot(tr.samples(:,1),tr.samples(:,p+1),'LineWidth',2,'Color',condColors(p));


% mark fixations
for n = 1:size(tr.fixations,1)
    ind = find(nativeTime==tr.fixations(n,1)):find(nativeTime==tr.fixations(n,2));
    hold on; f{1}= plot(tr.samples(ind,1),tr.samples(ind,p+1),':','LineWidth',1,'Color','k');
end

% mark blinks and fixations
for n = 1:size(tr.blinks,1)
    ind = find(nativeTime==tr.blinks(n,1)):find(nativeTime==tr.blinks(n,2));
    hold on; f{2}=plot(tr.samples(ind,1),tr.samples(ind,p+1),'o:');
end

% set axes
if exist('centerCrop','var') plotLim = [-centerCrop centerCrop; -centerCrop centerCrop]; axis square; end
ylim(plotLim(p,:));xlim([0 tr.samples(end,1)]);

% mark center
hold on;  hline(0,'k'); vline(0,'k'); 
yticks(plotLim(p,1):plotLim(p,2)); grid on;

% set legend (after we've adjusted axes etc.)
if size(tr.blinks,1)>1
l = legend([f{1} f{2}],{'Fixations','Blinks'}); 
else l = legend(f{1},{'Fixations'}); end
set(l,'FontSize',8,'box','off');

% titles, etc
title(plotText{p}); xlabel('Trial Time (s)'); ylabel(plotText{p});
end