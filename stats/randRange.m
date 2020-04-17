function [r] = randRange(range,n)
%[r] = randRange(range,n)
%  generate n random samples from uniform distribution of range [a b]
a = range(1);
b = range(2);
r = (b-a).*rand(n,1) + a;
end

