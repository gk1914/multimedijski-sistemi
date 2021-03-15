step = 0.03;
t = -pi:step:pi;
n = length(t);

figure(1), hold on, axis tight
for i = 1:n
    temp = cos((pi/n)*(i+0.5)*t);
    plot(temp)
end