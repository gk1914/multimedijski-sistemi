vid = read_video('shaky');

% display first frame and select point for tracking
frame1 = vid(:,:,:,1);
figure(1), imshow(frame1)
%[x,y] = ginput(1)

[trackX, trackY] = track_point(vid, 243, 178, 20, 100);

balanced(vid, trackX, trackY)
bal = read_video('stabilised');
v = VideoWriter('stabilised.avi');
open(v)
writeVideo(v, bal)
close(v)