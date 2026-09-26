% Exercise 7.10: DFT basics. The DFT of a discrete delta peak
% f[n] = delta[n] is F[k] = 1 for every k, and the IDFT returns f.

% ---- constants ----
N = 10;                         % number of samples [-]

% folders relative to this script, so it runs from any current folder
script_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(script_dir, '..'));  % helpers in src/
fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex7_10_dft_basics');
if ~isfolder(fig_dir)
    mkdir(fig_dir);
end

% delta peak: f(1) (MATLAB index 1, n = 0) is 1, all other samples 0
f = zeros(1, N);
f(1) = 1;

% DFT and IDFT
F = fft(f);
f_inv = ifft(F);
disp('F =');
disp(F);
disp('f_inv =');
disp(f_inv);

% sample indices and angular frequencies Omega_k = 2*pi*k/N [rad/sample]
n = 0:N-1;
k = 0:N-1;
Omega_k = 2*pi*k / N;

% plot f, |F| and the reconstructed f in one window
new_figure();
subplot(3, 1, 1);
stem(n, f, 'filled');
title('Time-domain signal f[n] = \delta[n]');
xlabel('Sample index n [-]');
ylabel('f[n] [-]');
grid on;
subplot(3, 1, 2);
stem(Omega_k, abs(F), 'filled');
title('DFT magnitude spectrum |F(\Omega_k)|');
xlabel('\Omega_k [rad/sample]');
ylabel('|F(\Omega_k)| [-]');
grid on;
subplot(3, 1, 3);
stem(n, real(f_inv), 'filled');
title('Reconstructed time-domain signal (ifft)');
xlabel('Sample index n [-]');
ylabel('f_{inv}[n] [-]');
grid on;
exportgraphics(gcf, fullfile(fig_dir, 'dft_delta.png'), 'Resolution', 200);
