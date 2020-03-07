function tr = eyetrackPreprocess(tr,eyeInit,rate)
% applies our basic eyetrack preprocessing: drift correction, recentering,
% coverting to dva, and zero-ing out time

if ~exist('rate','var') rate = 1000; end
if ~exist('eyeInit.mmScreen','var') eyeInit.mmScreen = [385.28 288.96]; end


tr.samples(:,2:3) =tr.samples(:,2:3)+repmat([tr.driftCorr],length(tr.samples),1);

% recenter to zero
plotLim = [-eyeInit.screen.width/2 eyeInit.screen.width/2; -eyeInit.screen.height/2 eyeInit.screen.height/2]; 
tr.samples(:,2:3) = tr.samples(:,2:3)-repmat([plotLim(1,2) plotLim(2,2)],length(tr.samples),1);

% set time to zero
nativeTime = tr.samples(:,1); % for indexing later
tr.samples(:,1) = (tr.samples(:,1)-tr.samples(1,1))/rate;

[plotLim,ppd] = pix2deg(plotLim,eyeInit.screen.width,eyeInit.mmScreen(1)/100,eyeInit.screenDist/100); 
tr.samples(:,2:3) = tr.samples(:,2:3)./ppd;


end

