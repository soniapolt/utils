function im = plotInSpace(data,dataDescr,xlab,addText,clim)

if ~exist('clim','var')|| isempty(clim)
    clim = [min(data(:)) max(data(:))]; 
    clim = [-max(clim) max(clim)];
end

numPlots = size(data,2)/size(data,1);

%%% to deal with nans
imAlpha=ones(size(data));
imAlpha(isnan(data))=0;

im = imagesc(data,clim); set(im,'AlphaData',imAlpha); 

pbaspect([numPlots 1 1]); 
colormap(mrvColorMaps('coolhot'));
%caxis([-max(clim) max(clim)])
caxis(clim)

%set(gca,'visible','off');
set(gca,'XTick',[],'YTick',[]);

if exist('addText','var') && addText==1
    for m = 1:size(data,1)
        for n = 1:size(data,2)
            text(n,m,num2str(data(m,n),2),'FontName','FixedWidth','FontSize',14,'Color','w','HorizontalAlignment','center');
        end
    end
    
end

for n = 1:numPlots-1
    l = vline(n*size(data,1)+0.5,'w'); set(l,'LineWidth',3);
end

if ~isempty(dataDescr)
t = title([dataDescr ' in Image Space']);
set(t,'visible','on');
end

if exist('xlab','var')&& ~isempty(xlab)
    x = xlabel(xlab); set(x,'visible','on'); end
pos = get(gca,'Position'); %[left, bottom, width, height].
if numPlots == 1
    barpos =  [pos(1)+pos(3)+.01, pos(2), .01, pos(4)];
else barpos = [pos(1)+pos(3)+.01, pos(2)+(pos(4)/(numPlots+1)), .01, pos(4)/numPlots];
end
c = colorbar('FontSize',12,'Box','off','Position',barpos);

end

