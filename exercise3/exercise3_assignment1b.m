freq = 400;
Fs = 44100;                                                                 % sampling frequency
t = [0:(1/Fs):1]';                                                          
A = 1;                                                                      % amplitude

y = A*sin(2*pi*freq*t);
figure(1)
plot(y(1:1000)), title('original')
%sound(y, Fs)

n = length(y);
y1 = y + rand(n,1);
figure(2)
plot(y1(1:1000)), title('noise 1')
scaled1 = y1/max(abs(y1));
%sound(y1, Fs)

y2 = y + randn(n,1);
figure(3)
plot(y2(1:1000)), title('noise 2')
scaled2 = y2/max(abs(y2));
%sound(y2, Fs)

y3 = y + randi(10,n,1);
figure(4)
plot(y3(1:1000)), title('noise 3')
scaled3 = y3/max(abs(y3));
%sound(y3, Fs)

%sound(scaled1, Fs)

