A = imread('umbrellas.jpg');
A_gray = rgb2gray(A);

figure(1);
colormap default;
imagesc(A_gray);

f2 = figure(2);
colormap gray;
imagesc(A_gray);