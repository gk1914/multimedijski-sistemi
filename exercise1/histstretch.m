function I2 = histstretch(I1)

max_val = max(I1(:))
min_val = min(I1(:))
max_out = 255;
min_out = 0;

f = (max_out - min_out) / (max_val - min_val);
I2 = ((I1 - min_val) * f);