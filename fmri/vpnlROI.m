function thisROI = vpnlROI(thisROI,subj)
if strcmp(thisROI(end-4:end),'faces')==1 || [exist('subj','var') && strcmp(subj,'SP')]
    thisROI = ['f_' thisROI];
else  thisROI = ['wfCSS_f_' thisROI];
end
% if avgSession ==1
%     thisROI = ['avg_' thisROI]; end
end

