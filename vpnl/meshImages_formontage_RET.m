
% Produce images of retinotopy prf model - phase and parameter maps
% (estimated one of a number of
% different ways) on a single-subject mesh
%
% JG 2016 - Changed for new map fit kid study.
% DF 2018 - changed for V1 myelination
% SP 2019 - changed for fixPRF project/sp-utils set-up
clear all; close all;

% inputs for this experiment
in.roi = standardROIs('EVC');
in.expt = 'fixPRF';
in.hem ='rh';
in.imagefile = [in.expt '_' in.hem '_EVC.png'];
in.subjs = {'SP' 'TH'};% 'EM' 'DF' 'MH' 'JG' 'MG' 'JJ' 'MZ' 'JW' 'JP' 'MN'};

%%%%%%%%%
% some defaults
in.map = 'retModel-cssFit-fFit.mat';
in.windowmin= 0.5;
in.windowmax = 80;
in.dataDir = '/share/kalanit/biac2/kgs/projects/invPRF/fixPRF/';
in.outDir = [in.dataDir '/montages'];
in.L.ambient = [.5 .5 .4];
in.L.diffuse = [.3 .3 .3];
in.whatmap='ph'; % ph = phase, ec = eccentricity, amp = pRF size;



in.meshAngle='rh_lat';%'rh_Medialzoom';
in.meshname='rh_inflated_200_1.mat';
in.clip=1;
in.colors = {'y' 'k' 'w' 'k' 'w' 'k' 'w' 'k', 'w'};
in.nrows=3;
in.ncols=4;
in.colbar=1; %0 = no color bar

f = figure('Position',[50 50 1800 1000]);
pause(1);

%%%%%%%%%

setpref('mesh', 'layerMapMode', 'all');
setpref('mesh', 'overlayLayerMapMode', 'mean');

% go to the session directory
for i =1:length(in.subjs)
    in.sess{i} = vpnlSessions(in.expt,in.subjs{i});
    cd(fullfile(in.dataDir, in.sess{i},'Retinotopy'));
    
    
    load mrSESSION.mat;
    clear dataTYPES mrSESSION vANATOMYPATH;
    
    hG = initHiddenGray('Averages',1);
    
    % load the ROI, get ready for the main loop
    
    % Delete from the list the ROIs the subject doesnt have
    toDelete = [];
    allMaps = in.roi;
    for m = 1:length(in.roi)
        allMaps{m} = vpnlROI([in.hem '_' in.roi{m}],in.subjs{i});
        if ~exist(fullfile('3DAnatomy','ROIs',[allMaps{m} '.mat']))
            toDelete(end+1) = m;
            fprintf('Missing %s!\n',[allMaps{m} '.mat']);
        end
    end
    allMaps(toDelete) = [];
    
    [hG , ok] = loadROI(hG, allMaps,[],[],[],0); % now loads shared maps, not local
    
    mapPath=fullfile(in.dataDir, in.sess{i}, 'Gray', 'Averages', in.map);
    
    % Change colors if specified
    if ~isempty(in.colors)
        for y=1:numel(hG.ROIs)
            hG.ROIs(y).color = in.colors{y};
        end
    end
    
    % load the user prefs -- meshColorOverlay needs a 'ui' field :P
    %enforce consistent preprocessing / event-related parameters
    
    %hG.ui = load('Gray/userPrefs.mat');
    hG.ui.dataTypeName= 'Averages'; % in case ui preferences are different
    % Load and clip the parameter map
    hG = rmSelect(hG,1,in.map);
    if strcmp(in.whatmap,'none')
    else
        hG = rmLoadDefault(hG);
    end;
    
    %%%%%%%%% which map do you want to load %%%%
    switch in.whatmap
        case 'ph'
            hG=setDisplayMode(hG,'ph');
            hG=refreshScreen(hG,1);
            hG.ui.displayMode='ph';
            hG.ui.phMode=setColormap(hG.ui.phMode, 'blueredyellowCmap');
            hG = cmapPolarAngleRGB(hG, 'both');
            % JG hardcoded a preset colormap for montage consistency
            cmapFile = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Retinotopy/code/Images/kidMap.mat';
            load(cmapFile);
            hG.ui.phMode.cmap = cmap;
        case 'amp'
            hG=setDisplayMode(hG,'amp');
            hG=refreshScreen(hG,1);
            hG.ui.displayMode='amp';
            cmapFile = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Retinotopy/code/Images/kidAmp.mat';
            load(cmapFile);
            front = repmat(cmap(1,:),272,1); cmap = vertcat(front,cmap);
            cmap = resample(cmap,16,33); cmap(cmap>1)=1;
            hG.ui.ampMode.cmap = cmap;
        case 'map'
            hG=setDisplayMode(hG,'map');
            hG=refreshScreen(hG,1);
            hG.ui.displayMode='map';
            hG.ui.mapMode=setColormap(hG.ui.mapMode,'hsvTbCmap');
    end
    
    %% load up a mesh for the view
    % first, we set the hemisphere, by setting the cursor position's 3rd dim.
    if isequal(lower(in.hem), 'rh')
        hG.loc = [100 100 1]; else hG.loc = [100 100 200];end
    
    % go into anatomy folder
    cd('3DAnatomy')
    % load the mesh
    hG = meshLoad(hG, in.meshname, 1); pause(2);
    
    cd(fullfile(in.dataDir,in.sess{i},'Retinotopy'));
    
    % set the view settings
    [mesh1, settings]=meshRetrieveSettings(hG.mesh{1}, in.meshAngle);
    
    % Recompute vertex
    vertexGrayMap = mrmMapVerticesToGray(...
        meshGet(mesh1, 'initialvertices'),...
        viewGet(hG, 'nodes'),...
        viewGet(hG, 'mmPerVox'),...
        viewGet(hG, 'edges'));
    hG.mesh{1} = meshSet(hG.mesh{1}, 'vertexgraymap', vertexGrayMap);
    
    
    hG.ui.roiDrawMethod = 'perimeter'; hG = refreshScreen(hG);
    
    % Set the mesh lighting to be the same across meshes
    meshLighting(hG, hG.mesh{1}, in.L, 1);
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
    %subplot_tight(in.nrows,in.ncols,plotNum);
    subplot(in.nrows,in.ncols,plotNum);
    imagesc(img{i});
    set(gca,'CameraViewAngle',get(gca,'CameraViewAngle')-.1);
    set(gcf,'color','w');
    axis image;
    axis off;
    myTitle = title(in.sess{i},'fontsize',10); set(myTitle,'interpreter','none');
    set(myTitle);
end


checkDir(in.outDir);
cd(in.outDir);
set(gcf,'PaperPositionMode','auto')
%saveas(f, [in.imagefile(1:end - 4) '.fig'], 'fig');
print ('-dpng', '-r400', in.imagefile);

