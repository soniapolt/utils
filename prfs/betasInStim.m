function im = betasInStim(data,ppd,gridSpace,faceSize,clim,addLines,cmap,cbar)
% for the pRF mapping experiments, more accurately plots beta values at
% stimulus position (including overlap)
if ~exist('clim','var')|| isempty(clim)
    clim = [min(data(:)) max(data(:))]; 
    clim = [-max(clim) max(clim)];
end
caxis(clim);
if ~exist('cmap','var') || isempty(cmap)
cmap = colormap('parula'); % cmap = brighten(colormap('jet'),.5); 
end
if ~exist('addLines','var') addLines = 0 ; end
if ~exist('cbar','var') || isempty(cmap) cbar = 1; end

im.grid = size(data,1);
im.size = round(ppd*((im.grid-1)*gridSpace+faceSize));
im.size = im.size+(10-mod(im.size,10))+50; 
im.gr =  ppd*gridSpace*([1:im.grid]-ceil(im.grid/2));
[X,Y]=(meshgrid(im.gr));X=X';Y=Y';

%%% sample centers across, then down
im.centers = [X(:)+im.size/2 Y(:)+im.size/2];
im.diam = faceSize*ppd;


[X,Y]=meshgrid(1:im.size,1:im.size);
allBetas = [];
for n = 1:im.grid
    for m = 1:im.grid
     
     if ~isnan(data(n,m)) 
         cent = im.centers(sub2ind([im.grid im.grid],m,n),:);
         allBetas(end+1,:,:) = data(n,m)*(sqrt((X - cent(1)).^2 + (Y - cent(2)).^2) <= im.diam/2);
     end
    end
end

allBetas(allBetas==0) = NaN;
meanBetas = squeeze(nanmean(allBetas));

imshow(meanBetas); colormap(cmap);caxis(clim);



if addLines
 hold on;
for n = 1:im.grid
    for m = 1:im.grid
     col =cmaplookup(data(n,m),clim(1),clim(2),0,cmap);
     if isnan(data(n,m)) alph = 0; else alph = 1; end
     c= plotCircle(im.centers(sub2ind([im.grid im.grid],m,n),1),im.centers(sub2ind([im.grid im.grid],m,n),2),...
         im.diam/2 ,col,alph,'edge'); set(c,'LineWidth',1); hold on;
     %plot(im.centers(sub2ind([im.grid im.grid],m,n),1),im.centers(sub2ind([im.grid im.grid],m,n),2),'.','MarkerSize',30,'Color',col); hold on;
    end
end
end

xlim([0 im.size]); ylim([0 im.size]); set(gca,'visible','on');
%col =cmaplookup(data(n,m),clim(1),clim(2),0,cmap);
%caxis(clim)

%set(gca,'visible','off');
set(gca,'XTick',[],'YTick',[]);

% set colorbar
%pos = get(gca,'Position'); %[left, bottom, width, height].
%barpos =  [pos(1)+pos(3)+.01, pos(2), .01, pos(4)];
if cbar
c = colorbar('FontSize',12,'Box','off');%,'Position',barpos);
end

h= hline(im.size/2,'k');v=vline(im.size/2,'k');%set(h,'LineWidth',2);set(v,'LineWidth',2);
for n = 1:5
hold on; c = plotCircle(im.size/2,im.size/2,n*ppd,'k',2,'edge'); %set(c,'LineStyle',':');
end

end

