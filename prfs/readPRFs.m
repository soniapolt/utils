function vox = readPRFs(vox,ppd,res,expN)
% converts the kayCSS/adjacent models parameters into a few more meaningful values
% kay pRF output is in image space = (1,1) is upper left, params are in
% (r,c) rather than (x,y); for any plotting, those params need a call of set(gca,'YDir','reverse');
% if expN is not fit by the model, it should be provided here

for v = 1:length(vox)
            vox(v).sdDeg = vox(v).params(3)/ppd;
            if exist('expN','var')
            vox(v).exp = expN; else vox(v).exp = vox(v).params(5); end
            vox(v).size = 2*vox(v).sdDeg/sqrt(vox(v).exp); % PRF size is defined as S/sqrt(N) - by KK
            vox(v).XYdeg = [(vox(v).params(2)-res/2)/ppd -(vox(v).params(1)-res/2)/ppd];
            vox(v).eccen = sqrt(vox(v).XYdeg(1)^2+vox(v).XYdeg(2)^2);
            vox(v).gain = vox(v).params(4);
            if length(vox(v).params)==6 % cssShift model
                vox(v).baseline = vox(v).params(6); end
            if length(vox(v).params)==9 || length(vox(v).params)==10
                vox(v).tempW = vox(v).params(end-4:end); % five weights for facetemp models
            elseif length(vox(v).params) == 8 % four weights for intemp models
            vox(v).tempW = vox(v).params(end-3:end);
           end 
        end
    end


