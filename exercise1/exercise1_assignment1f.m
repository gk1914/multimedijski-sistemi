A = imread('umbrellas.jpg');
A_gray = rgb2gray(A);

A_thr = A_gray > 150;
figure(1);
colormap gray;
imagesc(A_thr);