function t = onlyTitle(titleText)
% function t = onlyTitle(titleText)
% hides axis, shows title
t = title(titleText); set(gca,'visible','off'); set(t,'visible','on');
end

