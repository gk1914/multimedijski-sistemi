[x, Fs] = audioread('D_major2.wav');
org = x(:,1);
k = 25;
y = ((1+k)*org)./(1+k*abs(org));
scaled = y/max(abs(y));
sound(scaled, Fs)

figure(1), plot(org), title('original')
figure(2), plot(y), title('distorted')