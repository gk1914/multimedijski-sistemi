A = imread('monitor.jpg');
[h,w,d] = size(A);
B = imread('trucks.jpg');
[hB,wB,dB] = size(B);
Ad = double(A);
figure(1);
imshow(A);

%[x,y] = ginput(4)
xB = double([wB, 1, 1, wB]');
yB = double([1, 1, hB, hB]');


fileName = 'points.txt';
if exist(fileName, 'file')
    fileID = fopen(fileName, 'r');
    temp = fscanf(fileID, '%f')
    x = temp(1:4);
    y = temp(5:8);
else
    [x,y] = ginput(4);
    fileID = fopen(fileName, 'w');
    fprintf(fileID, '%f\n', x);
    fprintf(fileID, '%f\n', y);
end
fclose(fileID);


H = estimate_homography(x,y,xB,yB);
for j = 1:w
    for i = 1:h
        if inpolygon(j,i,x,y)
            pa = [j,i,1]';
            pb = H*pa;
            pb = pb./pb(3);
            A(i,j,:) = B(round(pb(2)),round(pb(1)),:);
        end
    end
end

figure(2)
imshow(A)
