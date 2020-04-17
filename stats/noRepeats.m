function [a] = noRepeats(a,sampleFrom)
%function [newA] = noRepeats(a,sampleFrom)
%   detects repeats at adjacent indices. useful for stimuli randomization
%   so we don't see 2x of the same thing in a row
for n = 2:length(a)
   while 1
       if a(n) ~= a(n-1)
           break
       end
       a(n) = datasample(sampleFrom,1);
   end
end

end

