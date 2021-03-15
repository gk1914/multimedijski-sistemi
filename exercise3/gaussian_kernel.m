function y = gaussian_kernel(width, sigma)

% width is the width of the produced kernel
% sigma defines the shape of the Gaussian function

x = linspace(-width / 2, width / 2, width);
y = exp(-x .^ 2 / (2 * sigma ^ 2));
y = y / sum (y); % normalize