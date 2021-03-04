function [bilatpar, clim, incr, cmap] = parinfo(param,datahem)
% function [bilatpar, clim, incr, cmap] = parinfo(param,datahem)
% outputs consistent cmap and clim info for prf model fit parameters,
% taking in at least the parname, and optionally the hem data (in a
% strucut) to concatenate

if ~exist('datahem','var') datahem = {}; end

            switch param
                case 'R2'
                    bilatpar = posrect(cat(1,datahem{:}));
                    clim = [0 100]; incr = 10;
                    cmap = hot;
                case 'predr'
                    bilatpar = cat(1,datahem{:});
                    clim = [0 1]; incr = .1;
                    cmap = hot;
                case 'angle'
                    bilatpar = cat(1,mod(180-datahem{1},360),datahem{2});
                    clim = [0 360]; incr = 30;
                    cmap = cmfanglecmapRH;
                case 'eccentricity'
                    bilatpar = cat(1,datahem{:});
                    clim = [0 5]; incr = .5;
                    cmap = cmfecccmap(4);
                case 'size'
                    bilatpar = cat(1,datahem{:});
                    clim = [0 10]; incr = 1;
                    cmap = cmfecccmap(7);
                case 'x'
                    bilatpar = cat(1,datahem{:});
                    clim = [-5 5]; incr = 1;
                    cmap = colormap_roybigbl;
                case 'y'
                    bilatpar = cat(1,datahem{:});
                    clim = [-5 5]; incr = 1;
                    cmap = colormap_roybigbl;
            end
end

