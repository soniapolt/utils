function [anovaData] = anova_rmSubjs(anovaData,rmSubjs)
%function  [anovaData] = anova_rmSubjs(anovaData,rmSubjs)
if ~isempty(rmSubjs) for s = unique(rmSubjs)
        anovaData(find(anovaData(:,end)==s),:) = []; 
        anovaData(find(anovaData(:,end)>s),end) = anovaData(find(anovaData(:,end)>s),end)-1; %% rmanova needs subject numbers to be consecutive
    fprintf('Removed data from subj #%d...\n',s); end
    end
end

