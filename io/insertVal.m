function outArray = insertVal(val,arr,inInd)
if size(arr,1)==1
outArray = [arr(1:inInd-1),val,arr(inInd:end)];
elseif size(arr,2)==1
outArray = [arr(1:inInd-1);val;arr(inInd:end)];    
end
end

