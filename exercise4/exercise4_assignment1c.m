Fs = 44100;
dt = 1/Fs;
t = 0:dt:0.01-dt;
signal = sin(2*pi*400*t);
figure(1), plot(signal), title('original')

coef = my_dct(signal);
reconstructed = my_idct(coef);
figure(2), plot(reconstructed), title('reconstructed'), grid on


% ------------------------------------------------------------------------
figure(3)
n = length(coef);
reconstructed = zeros(1,n);
X0 = coef(1)/n;
reconstructed = reconstructed + X0;
for i = 1:n-1
    for j = 0:n-1
        reconstructed(j+1) = reconstructed(j+1) + (2/n)*coef(i+1)*cos((pi/n)*i*(j+0.5));
    end
    waitforbuttonpress, plot(reconstructed), hold on, plot(signal, 'r'), hold off, title(['step-by-step recosntruction [i = ', num2str(i), ']'])
end

