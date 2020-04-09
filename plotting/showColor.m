function showColor(color)
% make a little figure that samples a color
for n = 1:3
mm(:,:,n) = repmat(color(n),100,100); end
imshow(mm);
end

