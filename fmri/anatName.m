function name = anatName(subjInitials)
% commonly used anatomy names
initials = {'JG' 'SP' 'EM' 'AS' 'TH' 'AR' 'MN'};
anats = {'jg201311' 'sp201803' 'em201611' 'awms201311' 'th201810' 'ar201810' 'mn201701'};

try
name = anats{ismember(initials,subjInitials)};
catch
  name = anats{ismember(lower(initials),subjInitials)};  
end
end

