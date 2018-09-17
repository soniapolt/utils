function name = anatName(subjInitials)
% commonly used anatomy names
initials = {'JG' 'SP' 'EM' 'AS'};
anats = {'jg201311' 'sp201803' 'em201611' 'awms201311'};

name = anats{ismember(initials,subjInitials)};
end

