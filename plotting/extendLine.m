function [y] = extendLine(lineObj,x)
%UNTITLED2 Summary of this function goes here
%%Extend line 
P1 = [lineObj.XData(1) lineObj.YData(1)]; 
P2 = [lineObj.XData(end) lineObj.YData(end)]; 

m = (P2(2)-P1(2))/(P2(1)-P1(1)) ;  % slope of line 

y = P1(2)+m*(x-P1(1)) ;  % y = y1+m*(x-x1) ;
end

