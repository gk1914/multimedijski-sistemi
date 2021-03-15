freq = 400;
Fs = 44100;                                                                 % sampling frequency
t = [0:(1/Fs):1]';                                                          

A = 1;                                                                      % amplitude
phase = 0;
y1 = A*sin(2*pi*freq*t + phase)
figure(1)
subplot(1,2,1)
plot(y1(1:500))
title('A = 1  &  phase = 0'), xlabel('sample #'), ylabel('amplitude')
axis([0 500 -1 1]), axis square

A = 0.5;
phase = pi;
y2 = A*sin(2*pi*freq*t + phase);
subplot(1,2,2)
plot(y2(1:500))
title('A = 0.5  &  phase = pi'), xlabel('sample #'), ylabel('amplitude')
axis([0 500 -1 1]), axis square

sound(y1, Fs)

