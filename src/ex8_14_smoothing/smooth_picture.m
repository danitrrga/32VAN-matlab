% Exercise 8.14: smoothing the newspaper picture of Jozias van Aartsen
% by convolving it with an L x L block of ones, using the convolution
% property (8.21): f ** g = IDFT2( F .* G ).

% ---- constants ----
L = 5;                          % side of the smoothing square [pixel]
L_values = [1, 5, 10, 20, 100]; % sides to compare at the end [pixel]

% folders relative to this script, so it runs from any current folder
script_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(script_dir, '..'));  % helpers in src/
image_file = fullfile(script_dir, '..', '..', 'data', 'van_aartsen.jpg');
fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex8_14_smoothing');

% Load image
f_raw = imread(image_file);

% imread loads the image in format uint8
% to avoid problems with the fourier we convert to decimals
f = double(f_raw);          % grey value of each pixel (0 = black, 255 = white)

[M, N] = size(f);           % M rows (y direction), N columns (x direction)

% DFT indices after fftshift: k = 0 in the middle, k_x means a pattern that
% repeats k_x times across the width of the picture [cycles per picture]
kx = (0:N-1) - floor(N/2);
ky = (0:M-1) - floor(M/2);

% Fourier spectra of the original image
F = fft2(f);

F_centered = fftshift(F);
% log(1 + |F|) because |F| spans many orders of magnitude
F_log = log(1 + abs(F_centered));

% Create g: same size as the picture, top-left L x L pixels equal to 1
g = zeros(M, N);
g(1:L, 1:L) = 1;

% Fourier spectra of g and pointwise product
G = fft2(g, M, N);
FG = F .* G;
FG_log = log(1 + abs(fftshift(FG)));

quickplot(F_log, "Fourier spectra of the original image", fullfile(fig_dir, "F_log.png"), ...
    "k_x [cycles per picture width]", "k_y [cycles per picture height]", kx, ky);
quickplot(FG_log, "Fourier spectra of the smoothed image", fullfile(fig_dir, "FG_log.png"), ...
    "k_x [cycles per picture width]", "k_y [cycles per picture height]", kx, ky);

% from the convolution theorem (8.21) we know that the F(f * g) = F(f) .* F(g)
f_convolution = real(ifft2(FG));

quickplot(f, "Original image", fullfile(fig_dir, "original.png"), "x [pixel]", "y [pixel]");
quickplot(f_convolution, "Smoothed image", fullfile(fig_dir, "f_convolution.png"), "x [pixel]", "y [pixel]");

% original and smoothed picture in one window
new_figure();
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

% direct (non-circular) convolution for comparison: convolve with the
% L x L block itself and keep the first M x N values, so the square has the
% same position as in the DFT result
direct_full = conv2(f, ones(L));
direct_convolution = direct_full(1:M, 1:N);

% away from the top and left edges there is no wrap-around, so both must agree
edge_free = abs(direct_convolution(L:end, L:end) - f_convolution(L:end, L:end));
fprintf('Max difference DFT vs direct convolution (away from edges): %.3g\n', max(edge_free(:)));
quickplot(direct_convolution, "Direct convolution", fullfile(fig_dir, "direct_convolution.png"), "x [pixel]", "y [pixel]");


% Explore with different Ls
for L = L_values
    g = zeros(M, N);
    g(1:L, 1:L) = 1;
    G = fft2(g, M, N);
    FG = F .* G;
    f_convolution = real(ifft2(FG));
    quickplot(f_convolution, sprintf("Smoothed image with L=%d", L), fullfile(fig_dir, sprintf("f_convolution_L%d.png", L)), "x [pixel]", "y [pixel]");
end
