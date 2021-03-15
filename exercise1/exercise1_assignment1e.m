A = imread('umbrellas.jpg');
A_gray = rgb2gray(A);

% originalna grayscale slika
figure(1);
imshow(A_gray);

% grayscale slika z invertiranim obmocjem
A_gray(100:250, 100:400, :) = 255 - A_gray(100:250, 100:400, :);
figure(2);
imshow(A_gray);