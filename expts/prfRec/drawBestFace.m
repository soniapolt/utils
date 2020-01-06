function [bestPos,sim] = drawBestFace(draw,sim,face)
% function [bestPos,sim] = drawBestFace(draw,sim,face)
% visualize simulation results & "best" face
% instead of draw, you can just directly give bestPos (x,y)

niceFig([.3 .3 .6 .6],12);
[X,Y]=(meshgrid(sim.steps));
faceSize = sim.faceSize*sim.ppd;
if size(draw) == [1,2]
    bestPost = draw; else
bestPos = [mean([draw.bestDegX]) mean([draw.bestDegY])]; 
%superTitle([num2str(sim.numSims) ' x  Monte Carlo, pRF coverage x face features (' num2str(sim.faceSize) 'deg)'],12,.02);
end

faceIm = zeros(sim.res+1,sim.res+1); co = CenterRectOnPoint([1 1 faceSize faceSize],round(bestPos(2)*sim.ppd)+sim.res/2+1,round(bestPos(1)*sim.ppd)+sim.res/2+1);
faceIm(co(1):co(3),co(2):co(4)) = face;

subplot(1,2,1); imshow(faceIm);
title(sprintf('Best Location: [%.2f (SD=%.2f) %.2f (SD=%.2f)] deg',bestPos(1),std([draw.bestDegX]),bestPos(2),std([draw.bestDegY])));

subplot(1,2,2);
sim.result = squeeze(mean(vertcat(draw.result)));
surface(X,Y,reshape(sim.result,length(sim.steps),length(sim.steps))); set(gca,'YDir','reverse');axis image;
title('All Sampled Locations');

end

