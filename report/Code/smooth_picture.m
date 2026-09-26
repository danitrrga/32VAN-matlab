% Exercise 8.14: smoothing the newspaper picture of Jozias van Aartsen
% by convolving it with an L x L block of ones, using the convolution
% property (8.21): f ** g = IDFT2( F .* G ).

% ---- constants ----
L = 5;                          % side of the smoothing square [pixel]
L_values = [1, 10, 100];        % sides to compare at the end [pixel]

% folders relative to this script, so it runs from any current folder
script_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(script_dir, '..'));  % helpers in src/
image_file = fullfile(script_dir, '..', '..', 'data', 'van_aartsen.jpg');
fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex8_14_smoothing');

% grey value of each pixel (0 = black, 255 = white); double for fft2
f = double(imread(image_file));
[M, N] = size(f);               % M rows (y direction), N columns (x direction)

% DFT indices after fftshift, k = 0 in the middle [cycles per picture]
kx = (0:N-1) - floor(N/2);
ky = (0:M-1) - floor(M/2);

% g: same size as the picture, top-left L x L pixels equal to 1
F = fft2(f);
g = zeros(M, N);
g(1:L, 1:L) = 1;
FG = F .* fft2(g);
f_smooth = real(ifft2(FG));     % (8.21)

% log(1 + |F|) because |F| spans many orders of magnitude
quickplot(log(1 + abs(fftshift(F))), "Fourier spectrum of the original image", ...
    fullfile(fig_dir, "F_log.png"), "k_x [cycles per picture width]", "k_y [cycles per picture height]", kx, ky);
quickplot(log(1 + abs(fftshift(FG))), "Fourier spectrum of the smoothed image", ...
    fullfile(fig_dir, "FG_log.png"), "k_x [cycles per picture width]", "k_y [cycles per picture height]", kx, ky);

new_figure();
subplot(1, 2, 1);
imagesc(f);
axis image;
title('Original image');
xlabel('x [pixel]');
ylabel('y [pixel]');
subplot(1, 2, 2);
imagesc(f_smooth);
axis image;
title(sprintf('Smoothed image, L = %d', L));
xlabel('x [pixel]');
ylabel('y [pixel]');
colormap(gray);
exportgraphics(gcf, fullfile(fig_dir, 'original_vs_smoothed.png'), 'Resolution', 200);

% check: direct (non-circular) convolution, first M x N values; away from
% the top and left edges there is no wrap-around, so both must agree
direct = conv2(f, ones(L));
diff_edge_free = abs(direct(L:M, L:N) - f_smooth(L:M, L:N));
fprintf('Max difference DFT vs direct convolution (away from edges): %.3g\n', max(diff_edge_free(:)));

for L_i = L_values
    g = zeros(M, N);
    g(1:L_i, 1:L_i) = 1;
    quickplot(real(ifft2(F .* fft2(g))), sprintf("Smoothed image with L = %d", L_i), ...
        fullfile(fig_dir, sprintf("f_convolution_L%d.png", L_i)), "x [pixel]", "y [pixel]");
end
