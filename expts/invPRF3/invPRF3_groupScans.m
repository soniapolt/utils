function invPRF3_groupScans(dt,session)
% runs from the subject directory in mrVista, fixes naming error, groups
% all pRF scans, assigns parfiles

load mrSESSION.mat;

for n = 1:length(dataTYPES(dt).scanParams)
    dataTYPES(dt).scanParams(n).annotation = ['prf' num2str(n)];
    dataTYPES(dt).scanParams(n).scanGroup = [dataTYPES(dt).name ': ' num2str(1:length(dataTYPES(dt).scanParams))];
    dataTYPES(dt).scanParams(n).parfile = [session '_invPRF3_run' num2str(n) '.par'];
    dataTYPES(dt).scanParams(n).inplanePath = [pwd '/Inplane/MotionComp_RefScan1/TSeries/tSeriesScan1.nii.gz']; % fixes a problem that was introduced when sonia re-organized project folder
end

save('mrSESSION.mat','mrSESSION','vANATOMYPATH','dataTYPES');

end