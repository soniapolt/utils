%function avgIms
% takes transformation of all of the face images, rather than
% session-specific

% what kind of image processing will we do?
% 1 = binary
% 2 = photo (abs contrast)
% 3 = energy per edge 2017 paper (remove low frequency, rectify)
% 4 = energy per mrVista (jw 2008 authorship?), which ends up being
% near-identicl to #2 (just normalizes differently at the end

im.which = 2; %
im.name = {'binary' 'photo' 'edge' 'other edge' 'internal'};
im.stims = 'external.mat';
im.saveName = 'extAvg.mat';

load(im.stims);

avgFace = cat(3,face{:});
avgFace = mean(avgFace,3);
subplot(1,2,1); imagesc(avgFace); title(['Average Face, ' im.saveName]);

im.backgroundColor = avgFace(1,1);

        if im.which == 2 || im.which > 5% photo
                % subtract background, take absolute value, divide by max
                avgFace = abs(avgFace-im.backgroundColor);
            elseif im.which == 3 % energy per edge 2017
                % convolve image with guassian kernel (SD = 6 in orig)
                % abs(orig - blurred), divide by max
                
                filtFace = conv2(make2DGaussian(size(avgFace,1),size(avgFace,1),.2*size(avgFace,1)/3.2),avgFace);
                centerFace = round(size(filtFace,1)/2+.5);
                filtCrop = filtFace(centerFace-size(avgFace,1)/2:centerFace+size(avgFace,1)/2-1,centerFace-size(avgFace,1)/2:centerFace+size(avgFace,1)/2-1);
                %images(:,:,n) = abs(ii - filtCrop);
                avgFace = abs(avgFace - filtCrop);
                %hack(1:40,:) = 0; hack(:,1:40) = 0;
               % hack(end-40:end,:) = 0; hack(:,end-40:end) = 0;
                %avgFace = hack;
            elseif im.which == 4 % energy per mrVista
                % subtract background intensity
                % rectify
                % divide by max (in a slightly different way that others - done
                % after all ims are aggregated
                avgFace = sqrt((avgFace-im.backgroundColor).^2);
            end


% normalize
if im.which == 4
    maxEnergy = max(max(avgFace(:))-im.backgroundColor,im.backgroundColor-min(avgFace(:)));
    avgFace = avgFace/maxEnergy;
else
    avgFace = avgFace/max(avgFace(:));
end

subplot(1,2,2); imagesc(avgFace); title(['Average Face, ' im.saveName]);

%save(['stimuli/' im.saveName],'avgFace');
%implay(condIms);
subplot(1,2,2); imshow(avgFace); title(im.name{im.which});
%end