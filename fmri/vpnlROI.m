function thisROI = vpnlROI(thisROI,subj,expt)

% commonly used subjects and ROI specifications
if ~exist('expt','var') || ~strcmp(expt,'invPRF3') % defaults
initials = {'JG'            'SP'                'EM'            'AS'        'TH'            'AR'            'MN'            'DF'            'MG'};
ret = {     'toonRet_f_'    'toonRet_f_'        'toonRet_f_'    'wfCSS_f_'  'toonRet_f_'    'toonRet_f_'    'toonRet_f_'    'toonRet_f_'    'toonRet_f_'};
face = {    'latprf_f_'     'latprf_f_'         'latprf_f_'     'f_'        'fLoc_f_'       'fLoc_f_'       'fLoc_f_'       'latprf_f_'     'latprf_f_'};

else
    switch expt
        case 'invPRF3'
        initials = {'JG'            'SP'        'MG'            'DF'        };
        ret = {     'wfCSS_f_'      'f_'        'wfCSS_f_'      'wfCSS_f_'  };
        face = {    'f_'            'f_'        'f_'            'f_'        };
   
    end
end


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

end

