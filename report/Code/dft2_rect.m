% Exercise 8.15: Fraunhofer pattern of a rectangle, DFT2 against the
% analytical result a*b*sinc(kx*a/2)*sinc(ky*b/2)

addpath('src')
D = 2;                  % size of the domain [m]
N_values = [513, 33];   % grid points, odd so the centre is a whole cell
Lxh = 4;                % half width and half height of the rectangle [cells]
Lyh = 2;

for N = N_values
    dx = D/N;
    x = (0:N-1) * dx;
    c = (N+1)/2;                % centre cell
    a = (2*Lxh + 1) * dx;       % width [m]
    b = (2*Lyh + 1) * dx;       % height [m]

    f = zeros(N);
    f(c-Lyh:c+Lyh, c-Lxh:c+Lxh) = 1;   % rows are y, columns are x

    k = (-(N-1)/2:(N-1)/2) * 2*pi/D;   % wave numbers after fftshift [rad/m]
    F = fftshift(dx^2 * fft2(f));      % times dx*dy to approximate the continuous FT

    % MATLAB's sinc(u) is sin(pi u)/(pi u), hence the 2*pi
    A = a * b * sinc(k * a / (2*pi)) .* sinc(k' * b / (2*pi));
    fprintf('N = %d: max difference %.3g (peak %.3g)\n', N, max(abs(abs(F(:)) - abs(A(:)))), max(A(:)))

    new_figure('Position', [100 100 1500 450]);
    subplot(1, 3, 1)
    imagesc(x, x, f)
    axis image
    title('(a) Rectangle')
    xlabel('x [m]'), ylabel('y [m]')
    grid on
    subplot(1, 3, 2)
    imagesc(k, k, abs(F))
    axis image
    title('(b) |DFT2|')
    xlabel('k_x [rad/m]'), ylabel('k_y [rad/m]')
    grid on
    subplot(1, 3, 3)
    imagesc(k, k, abs(A))
    axis image
    title('(c) Analytical')
    xlabel('k_x [rad/m]'), ylabel('k_y [rad/m]')
    grid on
    exportgraphics(gcf, sprintf('figures/ex8_15_diffraction/rect_N%d.pdf', N), 'Resolution', 200)
end
