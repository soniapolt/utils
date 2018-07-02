function invPRF3_groupScans(dt,session)
% runs from the subject directory in mrVista, fixes naming error, groups
% all pRF scans, assigns parfiles

for n = 1:length(dataTYPES(dt).scanParams)
    dataTYPES(dt).scanParams(n).annotation = ['prf' num2str(n)];
    dataTYPES(dt).scanParams(n).scanGroup = [dataTYPES(dt).name ': ' num2str(1:length(dataTYPES(dt).scanParams))];
    dataTYPES(dt).scanParams(n).parFile = [session '_invPRF3_run' num2str(n) '.par'];
end

saveSession;
end