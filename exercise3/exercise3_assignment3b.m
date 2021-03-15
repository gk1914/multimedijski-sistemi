load gong;

%----------------------------------------------
c = gaussian_kernel(64, 4);
c(2:2:end) = (-1)*c(2:2:end);
out = conv(y,c);
sound(out/max(abs(out)), Fs)

figure(1)
plot(y), title('original signal')
figure(2)
plot(out), title('result - high pass filtering')
figure(3)
plot(c), title('kernel')