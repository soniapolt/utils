function equalLim(XorY)
% set axis limits to be the same, default X as base
if ~exist('XorY','var') || strcmp(XorY,'x') || strcmp(XorY,'X')
    x = xlim; ylim(x);
elseif strcmp(XorY,'y') || strcmp(XorY,'Y')
    y = ylim; xlim(y);
else fprintf('Did not match axes limits, check function...\n');
end
end

