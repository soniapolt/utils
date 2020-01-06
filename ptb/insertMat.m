function bigMat = insertMat(x,y,smallMat,bigMat)
% function newMat = insertMat(cX,cY,smallMat,bigMat)
% like PTB's CenterRectOnPoint, inserts image matrix at a specific point of other image matric
%%% NOT FULLY BUILT YET

sz = size(smallMat);
cornerY = round(y-sz(1)/2);
cornerX = round(x-sz(2)/2);
insert = [cornerY, cornerY+sz(1)-1,
                cornerX, cornerX+sz(2)-1]

%%% BUILD THIS OUT LATER: needs to appropriately remove
%%% sections of smallMat that are off the edge
% don't go off the edge!            
% insert(insert<1) = 1;
% if insert(2)>size(bigMat,1) insert(2) = size(bigMat,1); end
% if insert(4)>size(bigMat,2) insert(4) = size(bigMat,2); end

bigMat(insert(1):insert(2),insert(3):insert(4)) = smallMat;

