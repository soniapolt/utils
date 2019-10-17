function [] = meshImages_formontage_PMAP_df(inputz)
% Produce images of a parameter maps
% (estimated one of a number of
% different ways) on a single-subject mesh
%
% JG 2016 - Changed for new map fit kid study.
% DF 2018 - changed for V1 myelination

setpref('mesh', 'layerMapMode', 'all');
setpref('mesh', 'overlayLayerMapMode', 'mean');


% go to the session directory
for i =1:size(inputz.sess,2)
    cd(fullfile(inputz.dataDir, inputz.sess{i}));
    
    load mrSESSION.mat;
    
    clear dataTYPES mrSESSION vANATOMYPATH;
    
    % Now load the appropriate datatype
    hG = initHiddenGray('Averages',1);
     

    %% load the ROI, get ready for the main loop
    
    % Delete from the list the ROIs the subject doesnt have
    toDelete = [];
    allMaps = inputz.roi;
    for m = 1:length(allMaps)
        if ~exist(fullfile('3DAnatomy','ROIs',[allMaps{m} '.mat']))
            toDelete(end+1) = m;
        end
    end
    allMaps(toDelete) = [];
    [hG , ok] = loadROI(hG, allMaps);
    mapPath=fullfile(inputz.dataDir, inputz.sess{i}, 'Gray', 'Averages', inputz.map);
    
    % Change colors if specified
    if ~isempty(inputz.colors)
        for y=1:numel(hG.ROIs)
            hG.ROIs(y).color = inputz.colors{y};
        end
    end
    %% load the user prefs -- meshColorOverlay needs a 'ui' field :P
    hG.ui = load('Gray/userPrefs.mat');
%     hG.ui.dataTypeName= 'Averages'; % in case ui preferences are different
    
    % Load and clip the parameter map
    hG = loadParameterMap(hG, inputz.map); 

    
    %%%%%%%%% which map do you want to load %%%%
%     if strcmp(inputz.whatmap,'ph')
%         hG=setDisplayMode(hG,'ph'); hG=refreshScreen(hG);
%     end
%     if strcmp(inputz.whatmap, 'amp')
%         hG=setDisplayMode(hG,'amp'); hG=refreshScreen(hG);
%         %  hG = rotateCmap(hG, 'flip');
%     end
%     
%     if strcmp(inputz.whatmap, 'map')
%         hG=setDisplayMode(hG,'map'); hG=refreshScreen(hG);
%     end
%     
    
    hG=refreshScreen(hG,1);
  
     if strcmp(inputz.whatmap, 'map')
        hG.ui.displayMode='map';
        hG.ui.mapMode=setColormap(hG.ui.mapMode,'hsvCmap');
        cmap = hsvCmap; %mrvColorMaps('autumn');
%          hG.ui.mapMode=setColormap(hG.ui.mapMode,'jetCmap');
%         cmap =jetCmap; %mrvColorMaps('autumn');
     end
     
      if strcmp(inputz.whatmap,'ph')
        hG.ui.displayMode='map';
        hG.ui.mapMode=setColormap(hG.ui.mapMode, 'bluegreenyellowCmap');
        %hG = cmapPolarAngleRGB(hG, 'both');
        % JG hardcoded a preset colormap for montage consistency
%         cmapFile = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Retinotopy/code/Images/kidMap.mat';
%         load(cmapFile);
%         hG.ui.mapMode.cmap = cmap;
    end
     
%     if inputz.colbar
%         cbar = cbarCreate(cmap);
%         cbar.clim = [inputz.windowmin inputz.windowmax];
%     end
			
   hG=setMapWindow(hG, [inputz.windowmin inputz.windowmax]);
    %% load up a mesh for the view
    % first, we set the hemisphere, by setting the cursor position's 3rd dim.
    if isequal(lower(inputz.hemisphere), 'rh')
        hG.loc = [100 100 1];
    else
        hG.loc = [100 100 200];
    end
        % go into anatomy folder
        cd('3DAnatomy')
        % load the mesh
        hG = meshLoad(hG, inputz.meshname, 1); pause(2);
        hG.ui.dataTypeName= 'Averages'; % in case ui preferences are different

        cd(fullfile(inputz.dataDir,inputz.sess{i}));
        
        % set the view settings
        [mesh1, settings]=meshRetrieveSettings(hG.mesh{1}, inputz.meshAngle);

        % Recompute vertex
        vertexGrayMap = mrmMapVerticesToGray(...
        meshGet(mesh1, 'initialvertices'),...
        viewGet(hG, 'nodes'),...
        viewGet(hG, 'mmPerVox'),...
        viewGet(hG, 'edges'));
        hG.mesh{1} = meshSet(hG.mesh{1}, 'vertexgraymap', vertexGrayMap);     
        
        hG.ui.roiDrawMethod = 'perimeter'; hG = refreshScreen(hG);
        
        %hG.ui.dataTypeName= 'Averages'; % in case ui preferences are different
        % Set the mesh lighting to be the same across meshes
        meshLighting(hG, hG.mesh{1}, inputz.L, 1);
        meshColorOverlay(hG);
        meshUpdateAll(hG);
        pause(2);
        
        % grab the snapshot and crop it if it is a ventral view
        img_temp= mrmGet(hG.mesh{1}, 'screenshot' ) ./ 255;
        %image_crop=img_temp(100:512, 100:512, :);
        %img{i}=image_crop;
        img{i}=img_temp;
        hG = meshDelete(hG, Inf); %close all meshes
        plotNum = i;
        %subplot_tight(inputz.nrows,inputz.ncols,plotNum,[0.04, 0.01]);
        %subplot_tight(inputz.nrows,inputz.ncols,plotNum);
        subplot(inputz.nrows,inputz.ncols,plotNum);
        imagesc(img{i}); 
        set(gca,'CameraViewAngle',get(gca,'CameraViewAngle')-.1);
        set(gcf,'color','w');
        axis image;
        axis off;
        %underscore = strfind(inputz.sess{i},'_');
        myTit = title(inputz.sess{i},'fontsize',10); set(myTit,'interpreter','none');
         set(myTit)
  
end
if inputz.colbar
    cbar = cbarCreate(cmap);
    cbar.cmap = cbar.cmap(128:224,:);
    cbar.nColors = 97;
    cbar.clim = [inputz.windowmin inputz.windowmax];
    subplot('Position', [0.05 0.05 .1 .04]);
    cbarDraw(cbar);
end

% % save
    cd('/biac2/kgs/projects/V1myelination/results/montages/');
    set(gcf,'PaperPositionMode','auto')
   % saveas(f, [inputz.imagefile(1:end - 4) '.fig'], 'fig');
    print ('-dpng', '-r400', inputz.imagefile);

    