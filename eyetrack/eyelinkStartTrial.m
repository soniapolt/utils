function eyelinkStartTrial(message)
% put a message with trial specifics at the top of the trial, starts recording
% this message text can be used to parse your ascii file later, so it is
% useful to save its format somewhere in your script. at minimum, it should
% include a trial number if your recording session consists of multiple
% trials

Eyelink('Message', message);
Eyelink('StartRecording');

end

