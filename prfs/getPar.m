function [pars] = getPar(parName,fits,dva)
% function [pars] = getPar(parName,fits,rescale)
% function to deal with extracting parameters, in raw or prfSet form, from
% our structs flexibly

parNum = cellNum(parName,fits.parNames);

if ~isempty(parNum)
    pars = vertcat(fits.vox.params);
    pars = pars(:,parNum)';
else
    eval(['pars = [fits.vox.' parName '];']);  end


%%% check that we have it
if isempty(pars)
    error(sprintf('Could not grab pars %s from struct!\n',parName));end


if dva && containsTxt(parName,'Y') || containsTxt(parName,'X') || containsTxt(parName,'sd')
    % rescale some parameters so that they are in DVA units and
    % centered around zero (center of screen)
    if ~containsTxt(parName,'sd') % don't re-center the SD
        pars = fits.res-pars-fits.res/2;
    end
    pars = pars./fits.ppd;
end

end

