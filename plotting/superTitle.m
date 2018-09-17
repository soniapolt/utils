function handle = superTitle(titleText,titleSize,vertPos)
% more flexible way of positioning a supertitle that won't mess up existing
% subplot titles
if ~exist('titleSize','var') titleSize = 14; end
if ~exist('vertPos','var') pos = [0, .94,1,.05]; 
else
pos = [0, vertPos,1,.05];  end

axes('Position',pos);
set(gca,'visible','off');
text(.5,0,titleText,'FontSize',titleSize,'FontWeight','bold','HorizontalAlignment','Center','VerticalAlignment','Bottom','Interpreter','none');

end

