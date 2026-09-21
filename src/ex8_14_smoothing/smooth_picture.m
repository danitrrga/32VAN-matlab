% clear; close all; clc;
colormap(gray);
% Load image

path = "Part 1 - Signals/MATLAB/data/van_aartsen.jpg";

f_raw = imread(path);

% imread loads the image in format uint8
% to avoid problems with the fourier we convert to decimals
f = double(f_raw);

[M, N] = size(f);

% Fourier spectra of the original image
F = fft2(f);

F_centered = fftshift(F);
F_log = log(1 + abs(F_centered));

% Create g
L = 5;
g = zeros(M, N);
g(1:L, 1:L) = 1;


% disp("Top-left section of g");
% disp(g(1:20, 1:20));


% Fourier spectra of g and pointwise product
G = fft2(g, M, N);
FG = F .* G;
FG_log = log(1 + abs(fftshift(FG)));

quickplot(F_log, "Fourier spectra of the original image", "figures/ex8_14_smoothing/F_log.png");
quickplot(FG_log, "Fourier spectra of the smoothed image", "figures/ex8_14_smoothing/FG_log.png");

% from the convolution theorem we know that the F(f * g) = F(f) .* F(g)
f_convolution = real(ifft2(FG));

quickplot(f, "Original image", "figures/ex8_14_smoothing/original.png");
quickplot(f_convolution, "Smoothed image", "figures/ex8_14_smoothing/f_convolution.png");

direct_convolution = conv2(f, g, 'same');
quickplot(direct_convolution, "Direct convolution", "figures/ex8_14_smoothing/direct_convolution.png");


% Explore with different Ls

L = [1, 5, 10, 20, 100];

for L = L
    g = zeros(M, N);
    g(1:L, 1:L) = 1;
    G = fft2(g, M, N);
    FG = F .* G;
    f_convolution = real(ifft2(FG));
    quickplot(f_convolution, sprintf("Smoothed image with L=%d", L), sprintf("figures/ex8_14_smoothing/f_convolution_L%d.png", L));
end