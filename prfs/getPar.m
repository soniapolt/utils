function [pars] = getPar(parName,fits,dva)
% function [pars] = getPar(parName,fits,rescale)
% function to deal with extracting parameters, in raw or prfSet form, from
% our structs flexibly

if ~isfield(fits,'parNames') fits.parNames = {'Y' 'X' 'sd' 'gain' 'exp'}; end

parNum = cellNum(parName,fits.parNames);

if ~isempty(parNum)
    pars = vertcat(fits.vox.params);
    pars = pars(:,parNum)';
else
    eval(['pars = [fits.vox.' parName '];']);  end


%%% check that we have it
if isempty(pars)
    error(sprintf('Could not grab pars %s from struct!\n',parName));end

% rescale some parameters so that they are in DVA units and
% centered around zero (center of screen)
if dva && containsTxt(parName,'Y')  % don't re-center the SD
    pars = -(pars-fits.res/2)/fits.ppd;
elseif dva && containsTxt(parName,'X')
    pars = (pars-fits.res/2)/fits.ppd;
elseif dva && containsTxt(parName,'sd')
    pars = pars/fits.ppd;
end

end
