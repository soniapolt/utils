function [sizeCh] = plotSizeChange2(vox1,vox2,ppd,res)
% make a plot of size changes of pRFs as a percentage of vox1 sizes
% red indicates increasing size, blue indicates decreasing size
% vox1/2 are struct vox.params (of standard pRF output)
% version 2 plots red/blue dots, rather than the magnitude of the size
% change

%res = 330; ppd = 30;
%vox1 = bFits(3).vox; vox2 = bFits(1).vox;
%figure;
set(gca,'YDir','reverse');

%basePix = 20; % a 100% change in size corresponds to this many pixels
colors = {[0 0 1]; [1 0 0]; [.5 .5 .5]}; % blue, red, grey

%concentric circles at each dva
for n = floor([0:1:(res/ppd)/2])
    a = plotCircle(res/2,-res/2,n*ppd,[0 0 0],.75,'edge'); % center
    set(a,'Linewidth',1); hold on;
end

 for v = 1:length(vox1)
    % calculate color
    size1 = [2*vox1(v).params(3)/sqrt(vox1(v).params(5))];
    size2 = [2*vox2(v).params(3)/sqrt(vox2(v).params(5))];
    sizeCh(v) = size2-size1;
    
    if sizeCh(v) == 0
        col = colors{3};
    elseif sizeCh(v)>0
        col = colors{2};
    else col = colors{1};end
    
        plotCircle(vox1(v).params(2),-vox1(v).params(1),2,col,.8,'fill'); % center
        hold on;
        plot(vox1(v).params(2),vox1(v).params(1),'Marker','.','Color',col); hold on;
    
 end
set(gca,'Visible','off'); hline(res/2,'k--'); vline(res/2,'k--');
axis([.5 res+.5 .5 res+.5]); axis square;

%end

