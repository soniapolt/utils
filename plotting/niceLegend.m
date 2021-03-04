function g = niceLegend(textCell,handle,fontSize)
% slightly better default values

if ~exist('fontSize','var') fontSize = 16;
    
    if exist('handle','var')
        g = legend(handle,textCell);
    else g = legend(textCell); end
    set(g,'box','off','FontSize',fontSize,'location','best');
end

