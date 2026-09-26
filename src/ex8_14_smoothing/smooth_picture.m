% Exercise 8.14: smoothing the newspaper picture with an L x L block of
% ones, using the convolution property (8.21)

addpath('src')
L = 5;                      % side of the block [pixel]
L_values = [1, 10, 100];    % other sizes to compare

f = double(imread('data/van_aartsen.jpg'));
[M, N] = size(f);
kx = (0:N-1) - floor(N/2);  % frequency index after fftshift
ky = (0:M-1) - floor(M/2);

F = fft2(f);
g = zeros(M, N);
g(1:L, 1:L) = 1;
FG = F .* fft2(g);
f_smooth = real(ifft2(FG));

% log because |F| covers many orders of magnitude
quickplot(log(1 + abs(fftshift(F))), 'Spectrum of the original', ...
    'figures/ex8_14_smoothing/F_log.png', 'k_x', 'k_y', kx, ky);
quickplot(log(1 + abs(fftshift(FG))), 'Spectrum after smoothing', ...
    'figures/ex8_14_smoothing/FG_log.png', 'k_x', 'k_y', kx, ky);

new_figure();
subplot(1, 2, 1)
imagesc(f)
axis image
title('Original')
xlabel('x [pixel]'), ylabel('y [pixel]')
subplot(1, 2, 2)
imagesc(f_smooth)
axis image
title(sprintf('Smoothed, L = %d', L))
xlabel('x [pixel]'), ylabel('y [pixel]')
colormap(gray)
exportgraphics(gcf, 'figures/ex8_14_smoothing/original_vs_smoothed.png', 'Resolution', 200)

% compare with conv2, away from the top and left edges where the DFT wraps
direct = conv2(f, ones(L));
d = abs(direct(L:M, L:N) - f_smooth(L:M, L:N));
fprintf('Max difference with conv2: %.3g\n', max(d(:)))

for L_i = L_values
    g = zeros(M, N);
    g(1:L_i, 1:L_i) = 1;
    quickplot(real(ifft2(F .* fft2(g))), sprintf('L = %d', L_i), ...
        sprintf('figures/ex8_14_smoothing/f_convolution_L%d.png', L_i), 'x [pixel]', 'y [pixel]');
end
