function thisROI = vpnlROI(thisROI,subj)

% commonly used subjects and ROI specifications
initials = {'JG'            'SP'                'EM'            'AS'        'TH'            'AR'            'MN'};
ret = {     'wfCSS_f_'      'toonRet_f_'        'toonRet_f_'    'wfCSS_f_'  'toonRet_f_'    'toonRet_f_'    'toonRet_f_'};
face = {    'f_'            'latprf_f_'         'latprf_f_'     'f_'        'fLoc_f_'       'fLoc_f_'       'fLoc_f_'};

try
    ret = ret{ismember(initials,subj)};
    face = face{ismember(initials,subj)};
catch
    ret = ret{ismember(lower(initials),subj)};  
    face = face{ismember(lower(initials),subj)};  
end

if containsTxt(thisROI,'faces')
    thisROI = [face thisROI];
else thisROI = [ret thisROI]; end

% if exist('subj','var') && strcmp(subj,'EM')
%  thisROI = ['latprf_f_' thisROI];       
% elseif strcmp(thisROI(end-4:end),'faces')==1 || [exist('subj','var') && strcmp(subj,'SP')]
%     thisROI = ['f_' thisROI];
% else  thisROI = ['wfCSS_f_' thisROI];
% end
% if avgSession ==1
%     thisROI = ['avg_' thisROI]; end
end

