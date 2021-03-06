function [edfName,el,eyeInit] = initEyelink(edfName)
% based on EyeLink_setup_recmem.m and vanderbilt ET code
% SP 2019 version
% initializes the screen and connects to EyeLink.
%
% edf name is optional input for file naming - must be 1-8 chars. for
% greater flexibility, call in 'tmp' and then rename the file after you've
% pulled it from the tracker machine
%
% now allows a custom calibration routine
%
% calls the following PTB functions:
% el=EyelinkInitDefaults;
% EyelinkDoTrackerSetup(el);
%

eyeInit.screen = Screen('Resolution', max(Screen('Screens'))); 
eyeInit.backgroundColor = [127 127 127];
eyeInit.screenDist = 540;       % distance from eye to screen, in mm
eyeInit.screenCoords = [-202.5 152.5 202.5 -152.5];     % in mm, the size of mitsubishi diamondpro2070sb display
eyeInit.saccadeSensitivity = 0; % 0 = normal sensitivity, 1 = high sensitivity
eyeInit.pointCalib = 9;         % n-point calibration (3 or 9)
eyeInit.autoCalib = 0;          % binary; 1 = enable automatic calibration
    
% new capability - for greater accuracy, we will manually adjust
% calibration to A) not sample the entire screen, since we are not showing
% stimuli in all of the corners etc, B) reduce the size of the targets.
% both of these choices should make calibration more accurate
eyeInit.customCalib = 1;
eyeInit.calibProp = .5;         % if eyeInit.customCalib, proportion of the screen that we will sample

% check ability to connect
try 
    Eyelink('initialize')
catch
    error('Error connecting to the Eyelink Eyetracker.\n'); 
end

% provide edf name, if not given by code
if ~exist('edfName','var') 
    edfName = inputdlg('EDF name? (1-8 chars, letters/numbers only)');
    edfName = edfName{1};
end

% initialize screen
Screen('Preference', 'SkipSynctests', 1);
[win, rect]=Screen('OpenWindow',max(Screen('Screens')),eyeInit.backgroundColor);
Screen(win, 'TextSize', 18); Screen(win,'TextFont','Arial'); [width, height]=Screen('WindowSize', win);
DrawFormattedText(win,'Initializing Eyetracker...', 'center', 'center', [0 0 0]);
Screen('Flip', win); %initial flip
WaitSecs(2);

% provide Eyelink with details about the graphics environment
% and perform some initializations. the information is returned
% in a structure that also contains useful defaults
% and control codes (e.g. tracker state bit and Eyelink key values).

el=EyelinkInitDefaults(win);
[~,eyeInit.version]=Eyelink('GetTrackerVersion');

% open file to record data to
i = Eyelink('Openfile', edfName);
if i~=0
    error('Cannot create EDF file ''%s'' ', edfName);
    Eyelink('Shutdown'); return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up tracker configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% saccade sensitivity
Eyelink('Command', ['select_parser_configuration  ' num2str(eyeInit.saccadeSensitivity)]);
% screen size (mm)
Eyelink('Command',['screen_phys_coords = ' num2str(eyeInit.screenCoords)]); 
% distance to eyes (mm)
Eyelink('Command', ['screen_distance = ' num2str(eyeInit.screenDist)]);
% screen size (taken internally)
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
% make note in edf file
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1)
% set calibration type.
Eyelink('command', ['calibration_type = HV' num2str(eyeInit.pointCalib)]);

% set the info that is written to each column of edf file - here
% this is filtered data for events (L & R are samples, other = events)
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
% set the info that is written to each column for raw data
Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,DIAMETER');
% set the info that is available to stimulus computer in real time via ethernet
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up custom calibration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

el.calibrationtargetsize = 1.2;
el.calibrationtargetwidth = .35;

if eyeInit.customCalib
    Eyelink('command', 'generate_default_targets = NO');
    
    xOffset = round((eyeInit.screen.width*eyeInit.calibProp)/2); 
    yOffset = round((eyeInit.screen.height*eyeInit.calibProp)/2);
    xc = round(eyeInit.screen.width/2); yc=round(eyeInit.screen.height/2);
    
    % layout/ordering (should work well with 9- or 5-point calib)
    %   6   4   7
    %   2   1   3
    %   8   5   9
    
    eyeInit.calibPoints = [[xc,yc] [xc-xOffset,yc] [xc+xOffset,yc] [xc,yc-yOffset] [xc,yc+yOffset] ...
                           [xc-xOffset,yc-yOffset] [xc+xOffset,yc-yOffset] ...
                           [xc-xOffset,yc+yOffset] [xc+xOffset,yc+yOffset]];
    
    
    Eyelink('command',['calibration_samples = ' num2str(eyeInit.pointCalib)]);
    Eyelink('command',sprintf(['calibration_sequence = ' repmat('%d,',1,eyeInit.pointCalib-1) '%d'],0:eyeInit.pointCalib-1));
    Eyelink('command',sprintf(['calibration_targets = ' repmat('%d,%d ',1,eyeInit.pointCalib)],...
        eyeInit.calibPoints));
    
    Eyelink('command',['validation_samples = ' num2str(eyeInit.pointCalib)]);
    Eyelink('command',sprintf(['validation_sequence = ' repmat('%d,',1,eyeInit.pointCalib-1) '%d'],0:eyeInit.pointCalib-1));
    Eyelink('command',sprintf(['validation_targets = ' repmat('%d,%d ',1,eyeInit.pointCalib)],...
        eyeInit.calibPoints));
    
else Eyelink('command', 'generate_default_targets = YES');   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if interested in other preferences, to get a list either
% 1) look through each ini file on host computer (c:\elcl\exe) or
% 2) look into log files for a given session (same directory)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make sure we're still connected to eyetracker
if Eyelink('IsConnected')~=1
    error('Eyetracker Connection Lost!')
    return;
end

% setup the proper calibration foreground and background colors
el.backgroundcolour = eyeInit.backgroundColor;
el.foregroundcolour = 0;
el.callback = [];
el.allowlocalcontrol = 1;

% runs calibration following an instruction screen
DrawFormattedText(win,['Ready for eyetracker calibration. Please fixate on the black dots as they appear on the screen;\n' ...
    num2str(eyeInit.pointCalib) ' dots will appear sequentially.\nYour experimenter will launch the calibration shortly.'], 'center', 'center', [0 0 0]);
Screen(win, 'Flip', 0); WaitSecs(5);

if eyeInit.autoCalib % automatic progression through calibration
Eyelink('command', 'enable_automatic_calibration = YES');	% YES default
Eyelink('command', 'automatic_calibration_pacing = 1000');	% 1000 ms default
end

EyelinkDoTrackerSetup(el);

eyeInit.eyeUsed = Eyelink('EyeAvailable');
Eyelink('SetOfflineMode');