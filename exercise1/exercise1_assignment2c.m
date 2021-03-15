A = imread('phone.jpg');
A_stretch = histstretch(A);

figure(1);
imshow(A);

figure(2);
imshow(A_stretch);

figure(3);
subplot(2,2,1); imshow(A);
subplot(2,2,2); [H1, bins] = myhist(A, 255); bar(H1);
subplot(2,2,3); imshow(A_stretch);
subplot(2,2,4); [H2, bins] = myhist(A_stretch, 255); bar(H2);