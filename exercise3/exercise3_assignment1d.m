freq = 400;
Fs = 44100;                                                                 % sampling frequency
dt = 1/Fs;
t = [0:dt:1-dt]';                                                          
A = 1;                                                                      % amplitude (0..1)

y1 = A*sin(2*pi*freq*t);
figure(1), plot(y1(1:500)), title('sine wave')


% -------------- square wave --------------------
sq = sign(sin(2*pi*freq*t));
figure(2), plot(sq(1:500)), title('square wave')


% -------------- triangle wave --------------------
tri = (2/pi)*asin(sin(2*pi*freq*t));
figure(3), plot(tri(1:500)), title('triangle wave')


% -------------- saw-tooth wave --------------------
%{
saw = [];
%tri = (2/pi)*asin(sin(2*pi*freq*t));
prev = tri(1);
start = 1;
rising = 1;
for i = 2:Fs
    curr = tri(i);
    if rising > 0 && curr < prev
        rising = -1;
        saw = [saw; tri(start:i-1)];
    elseif rising < 0 && curr > prev
        rising = 1;
        start = i;
    end
    prev = curr;
end
%}
saw = 2*(t*freq - floor(t*freq)) - 1;                                      % /oz. ...(t/perioda - floor(t/perioda)        
figure(4), plot(saw(1:500)), title('sawtooth wave')


% ------------------ play sound ---------------------------
sound2play = saw;
sound(sound2play, Fs)