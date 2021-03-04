function [samples] = eyeInSpace_scan(samples,ppd,fixRad,centerPos,centerCrop,noTime)
% based on eyeInSpace, but sparse for use with the scanner
%
% defaults to converting to degrees via ppd, takes center position (e.g.
% median across the run)
% - centerCrop: optionally plot only the center X degrees of the image (we likely aren't
% using all of the screen real estate)
% - markPoint: optionally mark an arbitrary point in stim space (e.g.
% corresponding to a stim presentation location);
% - noTime: binary telling us to ignore the time dimension (useful for
% collapsing across trials, for example)

%centerCrop = 5; tr = trial(1); markPoint = [-1 1]; dva = 1;
if ~exist('noTime','var') noTime = 0; end
if ~exist('centerCrop','var') centerCrop = 5; end
fixRad = .2; % fixation point

% recenter to zero
samples(:,2:3) = samples(:,2:3)-repmat([centerPos(1) centerPos(2)],length(samples),1);

% convert to dva
samples(:,2:3) = samples(:,2:3)./ppd;


% make plot

if noTime
    plot(samples(:,2),samples(:,3),'Color',[.2 .2 .2 .2]);
else
    surface([samples(:,2),samples(:,2)],[samples(:,3),samples(:,3),],[samples(:,1),...
        samples(:,1)],'EdgeColor','flat', 'FaceColor','none','EdgeAlpha',.1,'LineWidth',2);
    % make colorbar
    colormap(summer);
    time = 0:60:round(samples(end,1));
    matVer = version;
    if str2num(matVer(end-2)) >5
        cbar = colorbar('Ticks',time); cbar.Label.String= 'Time (seconds)';
    else cbar = colorbar('YTick',time); ylabel(cbar,'Time (seconds)')
    end
    
end


% set axes
if exist('centerCrop','var') plotLim = [-centerCrop centerCrop; -centerCrop centerCrop]; axis square; end
xlim(plotLim(1,:)); ylim(plotLim(2,:));

% mark center
hold on; hline(0,'k'); vline(0,'k');
hold on; viscircles([0,0],fixRad,'Color','k','LineStyle',':');
xticks(plotLim(1,1):plotLim(1,2)); yticks(plotLim(2,1):plotLim(2,2)); grid on;

    set(gca,'YDir','reverse');
samples = samples; % to return