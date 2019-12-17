
function [boot] = bootCoverage(vox,method,iters,numVox,doNorm)
% vox is a structure of v voxels with a params field

boot.numIters = iters;
boot.numVox = numVox; if boot.numVox < length(vox) boot.numVox = length(vox); end
boot.ppd = 10;
boot.res = 11 * boot.ppd;
boot.method = method; % 'max' or 'mean'
boot.rescale = doNorm; % rescale to 1 to 0

[X,Y]=meshgrid(-boot.res/2:boot.res/2,-boot.res/2:boot.res/2);

% make pRFs for all vox

for v = 1:length(vox)
    allPRFs(v,:,:) = PRF(X,Y,vox(v).XYdeg(1)*boot.ppd,vox(v).XYdeg(2)*boot.ppd,vox(v).size*boot.ppd);
end

covIm = zeros(boot.numIters,size(allPRFs,2),size(allPRFs,3));

% iteratively grab these
    parfor b = 1:length(boot.numIters)
    v = datasample([1:length(vox)],boot.numVox,'Replace',true)
    cov = allPRFs(v,:,:);
    
    % to deal with the issue of plot/imagesc using different coordinate systems
    cov = squeeze(cov);
    
    switch boot.method
        case 'max'
            cov = max(cov);
        case 'mean'
            cov = mean(cov);
    end
    covIm(b,:,:) = cov;
    end

    
 % average for the final coverage map
 boot.covIm = squeeze(mean(covIm));
 if doNorm boot.covIm = (boot.covIm-min(boot.covIm(:)))/(max(boot.covIm(:))-min(boot.covIm(:))); end
 
 % area of coverage
threshIm = im2bw(boot.covIm,max(boot.covIm(:))/2); % half-max of pRF coverage
boot.areaDeg = sum(threshIm(:))/(boot.ppd*boot.ppd);
boot.centers = vox.XYdeg;
boot.size = vox.size;
% boot.allCov = allPRFs; % this file becomes very large
 
 
    %imagesc(boot.covIm)
