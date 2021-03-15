Fs = 44100;
dt = 1/Fs;
t = 0:dt:1-dt;

org = rectpuls(t, 0.1);
figure(1), plot(t,org), title('original')%, axis([0 1 -0.2 1.2])

delay_in_seconds = 0.5;
delay_by_samples = round(delay_in_seconds*Fs);
c = zeros(1,length(org));
c(1) = 1;
c(delay_by_samples) = 1;
delayed = conv(org,c);
figure(2), plot(delayed), title('delay')
sound(delayed, Fs)