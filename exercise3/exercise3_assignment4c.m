[d, Fs] = audioread('D_major2.wav');
org = d(:,1);
duration = length(org)/Fs;
t = 0:1/Fs:duration-1/Fs;
figure(1), plot(org), title('original')

% flanger parameters
max_delay_seconds = 0.003;
max_delay_samples = round(max_delay_seconds*Fs);
A = 0.7;
sinusoid = sin(2*pi*1*t);
%plot(sinusoid)

% ------------- flanging ------------------------
y = org;
y(max_delay_samples+1:end) = 0;
for i = max_delay_samples+1:length(y)
    curr_delay = ceil(abs(sinusoid(i))*max_delay_samples);
    y(i) = org(i) + A*org(i-curr_delay);
end

% ------------- output --------------------------
figure(2), plot(y), title('flanged')
scaled = y/(max(abs(y)));
sound(scaled, Fs)
