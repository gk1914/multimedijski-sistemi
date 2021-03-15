Fs = 44100;
dt = 1/Fs;
t = 0:dt:1-dt;

pulse = rectpuls(t, 0.1);
%[d, Fs] = audioread('D_major2.wav');
%y = d(:,1);

y = ekko(pulse, Fs, 0.5, 0.6, 8);
figure(1), plot(y), title('echo'), xlabel('sample #'), ylabel('amplitude')
figure(2), plot(pulse), title('original'), xlabel('sample #'), ylabel('amplitude') 
sound(y/max(abs(y)), Fs)