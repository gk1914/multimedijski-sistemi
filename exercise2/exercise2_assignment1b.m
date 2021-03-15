shaky = read_video('shaky');

%play(shaky)

% OR
implay(shaky)

% OR
[h, w, c, n] = size(shaky)
figure(1)
for i = 1:n-1
    imshowpair(shaky(:,:,:,i), shaky(:,:,:,i+1), 'diff')
    waitforbuttonpress
end