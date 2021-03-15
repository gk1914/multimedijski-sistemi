A = imread('umbrellas.jpg');

% izrezana slika
cutout = A(100:250, 100:400, :);
figure(1);
imshow(cutout);

% prvotna slika z modrim kanalom == 0 v obmo?ju izreza
A(100:250, 100:400, 3) = 0;
figure(2);
imshow(A);