Fs = 44100;
dt = 1/Fs;
t = 0:dt:0.01-dt;
signal = sin(2*pi*400*t);
n = length(signal);
figure(1), subplot(1,2,1), plot(signal), title('original'), axis square, axis tight

dcmat = dct_coef(n);
dc = dcmat*signal';
reconstructed = (dcmat'*dc)';
subplot(1,2,2), plot(reconstructed), title('reconstructed'), axis square, axis tight