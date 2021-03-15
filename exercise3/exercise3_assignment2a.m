freq = 400;
Fs = 44100;                                                                 % sampling frequency
dt = 1/Fs;
t = [0:dt:1-dt]';
phase = pi;                                                                 % phase (in radians)
A = 1;                                                                      % amplitude


y1 = A*sin(2*pi*freq*t);
y1 = y1 + 0.8*sin(2*pi*freq*2*t) + 0.6*sin(2*pi*freq*4*t) + 0.4*sin(2*pi*freq*6*t) + 0.2*sin(2*pi*freq*8*t);
n = length(y1);
noisy = y1 + 2*randn(n,1);
figure(1)
subplot(1,2,1), plot(y1(1:500)), title('base signal'), xlabel('sample #'), ylabel('amplitude'), axis square
subplot(1,2,2), plot(noisy(1:500)), title('noisy signal'), xlabel('sample #'), ylabel('amplitude'), axis square
sound(y1/max(abs(y1)), Fs)

%---------------------- FFT --------------------------------
z1 = fft(y1);
z1 = abs(z1/n);
z1 = z1(1:n/2);
z1(2:end-1) = 2*z1(2:end-1);
fz = (0:n/2-1)*(Fs/n);

z2 = fft(noisy);
z2 = abs(z2/n);
z2 = z2(1:n/2);
z2(2:end-1) = 2*z2(2:end-1);
fz = (0:n/2-1)*(Fs/n);

%{
y2 = abs(fft(y1)/length(y1));
shifted = fftshift(y2);
f = (-n/2:n/2-1)*(Fs/n);
figure(3)
plot(f,shifted)
title('FFT (fftshift)'), xlabel('frequency [Hz]'), ylabel('amplitude')
%}


%---------------------- plot --------------------------------
figure(2)
subplot(1,2,1), plot(fz,z1), title('FFT - base signal'), xlabel('frequency [Hz]'), ylabel('amplitude'), axis square
subplot(1,2,2), plot(fz,z2), title('FFT - noisy signal'), xlabel('frequency [Hz]'), ylabel('amplitude'), axis square
