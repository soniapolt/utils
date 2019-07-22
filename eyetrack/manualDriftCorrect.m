function [corrX, corrY] = manualDriftCorrect(prompt,el,win,xc,yc,duration)
% since we're not sure that the Eyelink actually implements drift
% correction, gather fixation position manually, which can then be used to
% adjust

if ~exist('duration','var') duration = 2.5; end 
    buffer = 1; % time at the onset that we won't use for corr calculation
    fixRad = 4; % in pixels, radius of fixation dot.
    
    if prompt
        %%% prompt drift correction
        DrawFormattedText(win,['Eyetracking drift correction - fixate on the central dot.']...
            ,'center', 'center',[0 0 0]);
        Screen(win, 'Flip', 0); WaitSecs(2);
    end
    
    %
    bullseyeFix(win,xc, yc, fixRad, 1, [0 0 0],.5,1);
    gazeX = []; gazeY = [];
    
    [~,startRec,~,~] = Screen(win, 'Flip', 0);
    eyelinkStartTrial('DRIFTCORR_START');
    while 1
    if GetSecs-startRec > buffer
    [gazeX,gazeY] = eyelinkGetPosition(el,gazeX,gazeY);
                if GetSecs-startRec > duration
                    break;
                end
        end
    end
    eyelinkEndTrial('DRIFTCORR_END'); 
    corrX = xc-nanmedian(gazeX); corrY = nanmedian(gazeY)-yc;
%     figure; plot(gazeX); hold on; plot(gazeY); legend({['X=' num2str(corrX)] ['Y=' num2str(corrY)]});
%     hline(nanmedian(gazeY),'k:',num2str(nanmedian(gazeY))); hline(nanmedian(gazeX),'k:',num2str(nanmedian(gazeX)));
%end

