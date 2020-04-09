
function [boot] = bootCoverage(vox,method,iters,propVox,doNorm)
% vox is a structure of v voxels with a params field
% in this version, voxel number is given as a proportion and not a constant

boot.numIters = iters;
boot.propVox = propVox;
boot.numVox = round(propVox * length(vox));
boot.ppd = 10;
boot.res = 11 * boot.ppd;
boot.method = method; % 'max' or 'mean' or 'binary'
boot.rescale = doNorm; % rescale to 1 to 0

[X,Y]=meshgrid(-boot.res/2:boot.res/2,-boot.res/2:boot.res/2);

% make pRFs for all vox

for v = 1:length(vox)
    if ~strcmp(boot.method,'binary')
    allPRFs(v,:,:) = PRF(X,Y,vox(v).XYdeg(1)*boot.ppd,vox(v).XYdeg(2)*boot.ppd,vox(v).size*boot.ppd);
    else
        allPRFs(v,:,:) = (sqrt((X - vox(v).XYdeg(1)*boot.ppd).^2 + (Y - vox(v).XYdeg(2)*boot.ppd).^2) <= vox(v).size*boot.ppd);
    end   
        % sanity checking that these methods are the same:
%         a = PRF(X,Y,vox(v).XYdeg(1)*boot.ppd,vox(v).XYdeg(2)*boot.ppd,vox(v).size*boot.ppd);
%         b = (sqrt((X - vox(v).XYdeg(1)*boot.ppd).^2 + (Y - vox(v).XYdeg(2)*boot.ppd).^2) <= vox(v).size*boot.ppd);
%         figure; title(num2str(v)); subplot(1,3,1); imshow(a); subplot(1,3,2); imshow(b); 
%         C = imfuse(a,b,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
%         subplot(1,3,3); imshow(C);
    
end

covIm = zeros(boot.numIters,size(allPRFs,2),size(allPRFs,3));

% iteratively grab these
    parfor b = 1:boot.numIters
    v = datasample([1:length(vox)],boot.numVox,'Replace',true)
    cov = allPRFs(v,:,:);
    
    if boot.numVox>1
    switch boot.method
        case 'max'
            cov = max(cov);
        case 'mean'
            cov = mean(cov);
        case 'binary'
            cov = mean(cov);
    end
    end
    
    covIm(b,:,:) = cov;
    end

    
 % average for the final coverage map
 boot.covIm = squeeze(mean(covIm));
 if doNorm boot.covIm = (boot.covIm-min(boot.covIm(:)))/(max(boot.covIm(:))-min(boot.covIm(:))); end
 
 % area of coverage
threshIm = im2bw(boot.covIm,max(boot.covIm(:))/2); % half-max of pRF coverage
boot.areaDeg = sum(threshIm(:))/(boot.ppd*boot.ppd);
boot.centers = vertcat(vox.XYdeg);
boot.size = vertcat(vox.size);
% boot.allCov = allPRFs; % this file becomes very large
 
 
    %imagesc(boot.covIm)
