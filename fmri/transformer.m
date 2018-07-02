function [ nifti_xformed ] = transformer(nifti_file)
%transformer: performs the canonical nifti transformation on a list of
%nifti files, or you can leave it blank and it will run the transformation
%on all niftis in the current directory. 
%   Detailed explanation goes here

if isempty(nifti_file) 
    niftis = dir('*nii.gz*');
    nifti_file = {niftis.name};
end

for i = 1:length(nifti_file)
niftiWrite(niftiApplyCannonicalXform(niftiRead(nifti_file{i})),nifti_file{i});
fprintf('\nApplied cannonical transform to %s\n\n',nifti_file{i})
end

end

