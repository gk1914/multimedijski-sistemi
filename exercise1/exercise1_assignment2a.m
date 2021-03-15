A = imread('umbrellas.jpg');
A_gray = rgb2gray(A);

[H1, n1] = myhist(A_gray, 10);
[H2, n2] = myhist(A_gray, 20);
[H3, n3] = myhist(A_gray, 40);

figure(1);
subplot(1,3,1); bar(H1); axis square;
subplot(1,3,2); bar(H2); axis square;
subplot(1,3,3); bar(H3); axis square;