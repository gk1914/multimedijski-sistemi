freq = 400;
Fs = 44100;                                                                 % sampling frequency
dt = 1/Fs;
t = [0:dt:1-dt]';
phase = pi;                                                                 % phase (in radians)
A = 1;
n = length(t);


y = A*sin(2*pi*freq*t);

combined1 = y + 0.8*sin(2*pi*freq*2*t) + 0.6*sin(2*pi*freq*4*t) + 0.4*sin(2*pi*freq*6*t) + 0.2*sin(2*pi*freq*8*t);
combined2 = y + 0.8*sin(2*pi*freq*3*t) + 0.6*sin(2*pi*freq*5*t) + 0.4*sin(2*pi*freq*7*t) + 0.2*sin(2*pi*freq*9*t);

% plot combined harmonic signal
figure(1)
plot(combined1(1:500)), title('even multiples')
figure(2)
plot(combined2(1:500)), title('odd multiples')

% plot seperate harmonics with combined signal
period = round(1/(freq*dt)) + 2;
figure(3)
hold on
plot(combined1(1:period), ':')
plot(y(1:period), 'b')
harmonic = 0.8*sin(2*pi*freq*2*t);
plot(harmonic(1:period), 'g')
harmonic = 0.6*sin(2*pi*freq*4*t);
plot(harmonic(1:period), 'r')
harmonic = 0.4*sin(2*pi*freq*6*t);
plot(harmonic(1:period), 'c')
harmonic = 0.2*sin(2*pi*freq*8*t);
plot(harmonic(1:period), 'y')
title('all harmonics + combined')


sound(combined1/max(abs(combined1)), Fs)

