% Exercise 7.11: the DFT of a sampled cosine f(t) = cos(2*pi*nu_0*t).
% Expected peaks at nu = +-nu_0; the frequency resolution is 1/Dt.

% ---- constants ----
nu_0 = 440;                     % frequency of the cosine [Hz]
nu_s = 2000;                    % sampling frequency [Hz]
Dt = 1;                         % signal duration [s]

% folders relative to this script, so it runs from any current folder
script_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(script_dir, '..'));  % helpers in src/
fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex7_11_cosine');
if ~isfolder(fig_dir)
    mkdir(fig_dir);
end

T_s = 1 / nu_s;                 % sampling period [s]
N_s = round(nu_s * Dt);         % number of samples [-]

% sampled cosine
t = (0:N_s-1) * T_s;            % sampling times [s]
f = cos(2*pi*nu_0*t);
F = fft(f);

% frequency axis nu_k = k/Dt = k*nu_s/N_s [Hz]
d_nu = 1 / Dt;                  % frequency resolution [Hz]
nu = (0:N_s-1) * d_nu;

new_figure();
plot(nu, abs(F));
title('Raw DFT of the sampled cosine');
xlabel('Frequency \nu [Hz]');
ylabel('|F| [-]');
grid on;
exportgraphics(gcf, fullfile(fig_dir, 'raw_dft.png'), 'Resolution', 200);

% centre the spectrum around 0 Hz: after fftshift, index 0 moves to
% floor(N_s/2) + 1, so the negative frequencies lie left of 0
F_shifted = fftshift(F);
nu_shifted = ((0:N_s-1) - floor(N_s/2)) * d_nu;

new_figure();
plot(nu_shifted, abs(F_shifted));
title('Centred DFT of the sampled cosine');
xlabel('Frequency \nu [Hz]');
ylabel('|F| [-]');
grid on;
exportgraphics(gcf, fullfile(fig_dir, 'centred_dft.png'), 'Resolution', 200);

% for a real signal |F[N_s-k]| = |F[k]|, so the bottom half (DC up to the
% Nyquist frequency nu_s/2) contains all information
N_half = floor(N_s/2) + 1;

new_figure();
plot(nu(1:N_half), abs(F(1:N_half)));
title('Positive-frequency half of the DFT');
xlabel('Frequency \nu [Hz]');
ylabel('|F| [-]');
grid on;
exportgraphics(gcf, fullfile(fig_dir, 'positive_half_dft.png'), 'Resolution', 200);
