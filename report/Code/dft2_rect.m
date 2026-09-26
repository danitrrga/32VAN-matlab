% Exercise 8.15: the Fraunhofer diffraction pattern of a rectangular
% aperture, f(x,y) = rect(x/a) rect(y/b). Its DFT2 is compared with the
% analytical transform F(kx,ky) = a b sinc(kx a/2) sinc(ky b/2).

% ---- constants ----
D = 2;                          % size (x and y) of the calculation domain [m]
N_values = [513, 33];           % points in either direction; odd, so the
                                % middle cell (N+1)/2 is a whole number [-]
Lxh = 4;                        % half width of the rectangle [cells]
Lyh = 2;                        % half height of the rectangle [cells]

% folders relative to this script, so it runs from any current folder
script_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(script_dir, '..'));  % helpers in src/
fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex8_15_diffraction');
if ~isfolder(fig_dir)
    mkdir(fig_dir);
end

for N = N_values
    % spatial sampling period (cell size) in either direction [m]
    dx = D/N;
    dy = D/N;

    % centre of the rectangle [cell index]; width and height are
    % 2*Lxh+1 and 2*Lyh+1 cells
    Cx = (N+1)/2;
    Cy = (N+1)/2;

    % width and height of the rectangle [m]
    a = (2*Lxh + 1) * dx;
    b = (2*Lyh + 1) * dy;

    % x and y coordinates of the cells [m]
    x = (0:N-1) * dx;
    y = (0:N-1) * dy;

    % rectangle f: rows are y, columns are x
    f = zeros(N, N);
    f(Cy-Lyh:Cy+Lyh, Cx-Lxh:Cx+Lxh) = 1;

    % wave number resolution [rad/m] and wave numbers after fftshift;
    % N is odd, so they run symmetrically from -(N-1)/2 to (N-1)/2 steps
    dkx = 2*pi/D;
    dky = 2*pi/D;
    kx = (-(N-1)/2:(N-1)/2) * dkx;
    ky = (-(N-1)/2:(N-1)/2) * dky;

    % multiply with the cell size to approximate the spectrum of the
    % continuous (unsampled) function
    F = dx * dy * fft2(f);
    F_shifted = fftshift(F);

    % analytical result; MATLAB's sinc(u) = sin(pi u)/(pi u), so
    % sinc(k a/2) in the notes becomes sinc(k a/(2 pi)). ky is transposed
    % so that the product gives an N x N grid.
    A = a * b * sinc(kx * a / (2*pi)) .* sinc(ky' * b / (2*pi));

    fprintf('N = %d: max | |F| - |A| | = %.3g (max |A| = %.3g)\n', ...
        N, max(abs(abs(F_shifted(:)) - abs(A(:)))), max(abs(A(:))));

    new_figure('Position', [100 100 1500 450]);
    subplot(1, 3, 1);
    imagesc(x, y, f);
    axis image;
    title('(a) Rectangle f(x,y)');
    xlabel('x [m]');
    ylabel('y [m]');
    grid on;
    subplot(1, 3, 2);
    imagesc(kx, ky, abs(F_shifted));
    axis image;
    title('(b) Numerical spectrum |F| (DFT2)');
    xlabel('k_x [rad/m]');
    ylabel('k_y [rad/m]');
    grid on;
    subplot(1, 3, 3);
    imagesc(kx, ky, abs(A));
    axis image;
    title('(c) Analytical spectrum |A|');
    xlabel('k_x [rad/m]');
    ylabel('k_y [rad/m]');
    grid on;
    exportgraphics(gcf, fullfile(fig_dir, sprintf('rect_N%d.pdf', N)), 'Resolution', 200);
end
