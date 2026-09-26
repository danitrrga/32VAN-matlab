% Exercise 7.12: find the note played by a violin in unknown_note.wav
% from the highest peak of its magnitude spectrum.

% ---- constants ----
nu_plot_max = 2000;             % upper limit of the plotted range [Hz]

% folders relative to this script, so it runs from any current folder
script_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(script_dir, '..'));  % helpers in src/
sound_file = fullfile(script_dir, '..', '..', 'data', 'unknown_note.wav');
fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex7_12_violin');
if ~isfolder(fig_dir)
    mkdir(fig_dir);
end

% read the recording; keep the first channel if it is stereo
[f, nu_s] = audioread(sound_file);  % samples [-], sampling frequency [Hz]
f = f(:, 1);
N_s = length(f);                % number of samples [-]

% DFT and frequency of each bin nu_k = k*nu_s/N_s [Hz]
F = fft(f);

% bottom half of the spectrum, DC up to the Nyquist frequency nu_s/2
% (includes the Nyquist bin when N_s is even)
N_half = floor(N_s/2) + 1;
nu = (0:N_half-1)' * nu_s / N_s;
F_half = abs(F(1:N_half));

new_figure();
plot(nu, F_half);
title('Frequency spectrum of unknown\_note.wav (DC to Nyquist)');
xlabel('Frequency \nu [Hz]');
ylabel('|F(\nu)| [-]');
xlim([0 nu_plot_max]);
grid on;
exportgraphics(gcf, fullfile(fig_dir, 'unknown_note_spectrum.png'), 'Resolution', 200);

% the fundamental is the highest peak
[~, i_max] = max(F_half);
nu_0 = nu(i_max);
fprintf('Base frequency: %.2f Hz\n', nu_0);
