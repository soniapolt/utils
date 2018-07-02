function misFace = splitFace(face,splitH,splitV,gap,leftR)
% create misAligned faces & binary stims 

backgr = face(1,1); % ~128 for photos, 0 for binary stims

    misFace = ones(size((face),1)+gap,size((face),2)+2*splitV)*backgr;
    if leftR == 1 % shift top left, bottom right
        top = face(1:splitH,:); bottom = face(splitH+1:end,:);
        misFace(1:size(top,1),1:size(top,2)) = top; % shift left
        misFace(size(top,1)+gap+1:end,end-size(bottom,2)+1:end) = bottom; % shift right
    else % shift top right, bottom left
        top = face(1:splitH,:); bottom = face(splitH+1:end,:);
        misFace(1:size(top,1),end-size(top,2)+1:end) = top; % shift left
        misFace(size(top,1)+gap+1:end,1:size(bottom,2)) = bottom; % shift right
    end
end

