function playSound
% plays a brief chirp, mostly to indicate code is done
load chirp
sound(y(1:round(end/5)),Fs);

end

