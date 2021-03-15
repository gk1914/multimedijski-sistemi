function n = balance_smooth(img_sequence, tx, ty)
%PLAY Summary of this function goes here
%   Detailed explanation goes here

[h, w, c, n] = size(img_sequence)

figure(13), imshow(img_sequence(:,:,:,1))
imwrite(img_sequence(:,:,:,1), strcat('smoothed/', sprintf('%08d', 1), '.jpg'))
orgX = tx(1);
orgY = ty(1);
dx = tx(1) - tx;
dy = ty(1) - ty;
[sx sy] = smooth_trajectory(dx, dy);
sx = floor(sx);
sy = floor(sy);

for i = 2:n
    dX = sx(i);
    dY = sy(i);
    curr_frame = img_sequence(:,:,:,i);
    %transposed = zeros(h,w,c);
    x1 = max(1, 1 - dX);
    x2 = min(w, w - dX);                                                   
    y1 = max(1, 1 - dY);
    y2 = min(h, h - dY);                                                    
    transposed = curr_frame(y1:y2, x1:x2, :);
    if dX >= 0
       transposed = padarray(transposed, [0,dX], 'pre');
    else
        transposed = padarray(transposed, [0,abs(dX)], 'post');
    end
    if dY >= 0
       transposed = padarray(transposed, [dY,0], 'pre');
    else
        transposed = padarray(transposed, [abs(dY),0], 'post');
    end
    size(transposed)
    imshow(transposed)
    imwrite(transposed, strcat('smoothed/', sprintf('%08d', i), '.jpg'))
    %waitforbuttonpress
end

