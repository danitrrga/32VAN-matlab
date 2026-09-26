% Exercise 7.12: which note does the violin play?

addpath('src')
nu_plot = 2000;     % plot the spectrum up to this frequency [Hz]

[f, nu_s] = audioread('data/unknown_note.wav');
f = f(:, 1);
N_s = length(f);
F = abs(fft(f));

% up to the Nyquist frequency, the rest is the mirror image
half = 1:floor(N_s/2)+1;
nu = (half - 1)' * nu_s / N_s;

new_figure();
plot(nu, F(half))
title('Spectrum of unknown\_note.wav')
xlabel('Frequency [Hz]')
ylabel('|F|')
xlim([0 nu_plot])
grid on
exportgraphics(gcf, 'figures/ex7_12_violin/unknown_note_spectrum.png', 'Resolution', 200)

[~, i_max] = max(F(half));
fprintf('Base frequency: %.2f Hz\n', nu(i_max))
