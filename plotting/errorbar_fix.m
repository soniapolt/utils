function [hb] = errorbar_fix(ha,color)
% removes horizontal ticks in errorbars
hb = get(ha,'children'); 
Xdata = get(hb(2),'Xdata');
temp = 4:3:length(Xdata);
temp(3:3:end) = [];
% xleft and xright contain the indices of the left and right
%  endpoints of the horizontal lines
xleft = temp; xright = temp+1;
% Increase line length by 0.2 units
Xdata(xleft) = 0;
Xdata(xright) = 0;
set(hb(2),'Xdata',Xdata);
if ~exist('color','var')
set(hb(2),'Color','k');
else set(hb(2),'Color',color);  
end

