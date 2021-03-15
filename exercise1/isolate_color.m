function I2 = isolate_color (I, mask)

% assume rgb image
I_gray = rgb2gray(I);
I_background = I_gray;
I_background(mask)=0;

c1 = I(:,:,1);
c2 = I(:,:,2);
c3 = I(:,:,3);

c1_foreground = c1;
c1_foreground(~mask)=0;
c2_foreground = c2;
c2_foreground(~mask)=0;
c3_foreground = c3;
c3_foreground(~mask)=0;

I2 = cat(3,I_background+c1_foreground, I_background+c2_foreground,I_background+c3_foreground);


end