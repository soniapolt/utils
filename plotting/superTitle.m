function handle = superTitle(titleText,titleSize)
% more flexible way of positioning a supertitle that won't mess up existing
% subplot titles

axes('Position',[0, .97,1,.05]);
set(gca,'visible','off');
text(.5,0,titleText,'FontSize',titleSize,'FontWeight','bold','HorizontalAlignment','Center','VerticalAlignment','Bottom','Interpreter','none');

end

