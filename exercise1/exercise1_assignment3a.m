A = imread('trucks.jpg');
A_hsv = rgb2hsv(A);
A_gray = rgb2gray(A);

% RGB image and its seperate channels
figure(1);
subplot(2,4,1);
imshow(A);
subplot(2,4,2);
imshow(A(:,:,1));
subplot(2,4,3);
imshow(A(:,:,2));
subplot(2,4,4);
imshow(A(:,:,3));

% HSV channels
subplot(2,4,6);
imshow(A_hsv(:,:,1));
subplot(2,4,7);
imshow(A_hsv(:,:,2));
subplot(2,4,8);
imshow(A_hsv(:,:,3));
