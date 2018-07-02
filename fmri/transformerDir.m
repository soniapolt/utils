function [ nifti_xformed ] = transformerDir(niftiDir)
%transformer: performs the canonical nifti transformation on a list of
%nifti files, or you can leave it blank and it will run the transformation
%on all niftis in the current directory.
%   adapted from JG's code by SP (oct2017) to access a directory of niftis
%   rather than individual files


if ~exist('niftiDir','var')
    niftiDir = pwd;
end
codeDir = pwd;

cd(niftiDir);
niftis = dir('*nii.gz*');
nifti_file = {niftis.name};

% eliminates files starting with ._ - why are these formed?
nifti_file = {nifti_file{~strncmp(nifti_file, '._',2)}};

for i = 1:length(nifti_file)
    niftiWrite(niftiApplyCannonicalXform(niftiRead(nifti_file{i})),nifti_file{i});
    fprintf('\nApplied cannonical transform to %s\n\n',nifti_file{i})
end

cd(codeDir);

%end

