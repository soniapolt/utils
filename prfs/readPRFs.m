function vox = readPRFs(vox,ppd,res)
% converts the kayCSS/cssShift parameters into a few more meaningful values
% kay pRF output is in image space = (1,1) is upper left, params are in
% (r,c) rather than (x,y); for any plotting, those params need a call of set(gca,'YDir','reverse');

for v = 1:length(vox)
            vox(v).sdDeg = vox(v).params(3)/ppd;
            vox(v).size = 2*vox(v).sdDeg/sqrt(vox(v).params(5)); % PRF size is defined as S/sqrt(N) - by KK
            vox(v).XYdeg = [(vox(v).params(2)-res/2)/ppd -(vox(v).params(1)-res/2)/ppd];
            vox(v).eccen = sqrt(vox(v).XYdeg(1)^2+vox(v).XYdeg(2)^2);
            vox(v).gain = vox(v).params(4);
            if length(vox(v).params)>5 % cssShift model
                vox(v).baseline = vox(v).params(6); end
        end
    end


