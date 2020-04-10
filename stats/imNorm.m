function [imn] = imNorm(im)
% normalized an image im from 0 to 1
imn = (im- min(im(:))) / ( max(im(:)) - min(im(:)) );
end

