% clear; close all; clc;
colormap(gray);
% Load image

% folders relative to this script, so it runs from any current folder
script_dir = fileparts(mfilename('fullpath'));
image_file = fullfile(script_dir, '..', '..', 'data', 'van_aartsen.jpg');
fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex8_14_smoothing');

f_raw = imread(image_file);

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

quickplot(F_log, "Fourier spectra of the original image", fullfile(fig_dir, "F_log.png"));
quickplot(FG_log, "Fourier spectra of the smoothed image", fullfile(fig_dir, "FG_log.png"));

% from the convolution theorem we know that the F(f * g) = F(f) .* F(g)
f_convolution = real(ifft2(FG));

quickplot(f, "Original image", fullfile(fig_dir, "original.png"));
quickplot(f_convolution, "Smoothed image", fullfile(fig_dir, "f_convolution.png"));

% original and smoothed picture in one window
figure('Color', 'w');
subplot(1, 2, 1);
imagesc(f);
axis image;
title('Original image');
xlabel('x [pixel]');
ylabel('y [pixel]');
subplot(1, 2, 2);
imagesc(f_convolution);
axis image;
title(sprintf('Smoothed image, L = %d', L));
xlabel('x [pixel]');
ylabel('y [pixel]');
colormap(gray);
exportgraphics(gcf, fullfile(fig_dir, 'original_vs_smoothed.png'), 'Resolution', 200);

direct_convolution = conv2(f, g, 'same');
quickplot(direct_convolution, "Direct convolution", fullfile(fig_dir, "direct_convolution.png"));


% Explore with different Ls

L = [1, 5, 10, 20, 100];

for L = L
    g = zeros(M, N);
    g(1:L, 1:L) = 1;
    G = fft2(g, M, N);
    FG = F .* G;
    f_convolution = real(ifft2(FG));
    quickplot(f_convolution, sprintf("Smoothed image with L=%d", L), fullfile(fig_dir, sprintf("f_convolution_L%d.png", L)));
end