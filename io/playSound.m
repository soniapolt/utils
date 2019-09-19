function playSound(n,duration)
if ~exist('n','var') n = 1; end
if ~exist('duration','var') duration = .3; end
% plays a brief chirp, mostly to indicate code is done

switch n
    case 1
        load chirp 
        sound(y(100:round(duration*Fs)),Fs);
    case 2
        amp=10; Fs=8192;  % sampling frequency
        freq=100;
        sound(amp*sin(2*pi* freq*[0:1/Fs:duration]))
    case 3
        beep
end

end

