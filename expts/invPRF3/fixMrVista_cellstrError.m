% fixes common mrVista error, in which first scan of series is not assigned its
% name (a string) but a number

clx;
load('mrSESSION.mat');
for n = 1:length(dataTYPES(end).scanParams)
dataTYPES(end).scanParams(n).annotation = ['prf' num2str(n)];
end
save mrSESSION.mat mrSESSION dataTYPES vANATOMYPATH;
clx

