function c = plotCircle(x,y,r,color,alphaVal,colorWhat)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
c = patch(x+xp,-y+yp,color);

if alphaVal <0 || isnan(alphaVal)==1
alphaVal = .0001; 
elseif alphaVal> 1 alphaVal = .99;
end
if strcmp(colorWhat,'edge') == 1
set(c,'FaceAlpha',alphaVal,'EdgeAlpha',alphaVal,'FaceColor','none','EdgeColor',color);
elseif strcmp(colorWhat,'fill') == 1
set(c,'FaceAlpha',alphaVal,'EdgeAlpha',alphaVal,'FaceColor',color,'EdgeColor','none');    
end
end