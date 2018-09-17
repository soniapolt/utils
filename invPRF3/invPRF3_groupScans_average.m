function invPRF3_groupScans_average(dt,parfilePre,sessNum)
% runs from the subject directory in mrVista, fixes naming error, groups
% all pRF scans, assigns parfiles

if ~exist('sessNum','var') sessNum = 2; end % how many sessions are we averaging? defualt = 2

load mrSESSION.mat;
numUniq = (length(dataTYPES(dt).scanParams)/sessNum);

for n = 1:numUniq
    for m = numUniq.*[(1:sessNum)-1]
        dataTYPES(dt).scanParams(m+n).annotation = ['prf' num2str(n)];
        dataTYPES(dt).scanParams(m+n).scanGroup = [dataTYPES(dt).name ': ' num2str(1:length(dataTYPES(dt).scanParams))];
        dataTYPES(dt).scanParams(m+n).parfile = [parfilePre '_invPRF3_run' num2str(n) '.par'];
    end
end

    save('mrSESSION.mat','mrSESSION','vANATOMYPATH','dataTYPES');
    
end