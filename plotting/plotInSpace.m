function im = plotInSpace(data,dataDescr,xlab,addText,clim)

if ~exist('clim','var')
    clim = [min(data(:)) max(data(:))]; end

numPlots = size(data,2)/size(data,1);

im = imagesc(data,clim); pbaspect([numPlots 1 1]); colormap(mrvColorMaps('coolhot'));set(gca,'visible','off');

if exist('addText','var')
    for m = 1:size(data,1)
        for n = 1:size(data,2)
            text(n,m,num2str(data(m,n),2),'FontName','FixedWidth','FontSize',14,'Color','w','HorizontalAlignment','center');
        end
    end
    
end

for n = 1:numPlots-1;
    l = vline(n*size(data,1)+0.5,'w'); set(l,'LineWidth',3);
end

t = title([dataDescr ' in Image Space']);
set(t,'visible','on');
if exist('xlab','var')
    x = xlabel(xlab); set(x,'visible','on'); end
pos = get(gca,'Position'); %[left, bottom, width, height].
if numPlots == 1
    barpos =  [pos(1)+pos(3)+.01, pos(2), .01, pos(4)];
else barpos = [pos(1)+pos(3)+.01, pos(2)+(pos(4)/(numPlots+1)), .01, pos(4)/numPlots];
end
c = colorbar('FontSize',12,'Box','off','Position',barpos);
end

