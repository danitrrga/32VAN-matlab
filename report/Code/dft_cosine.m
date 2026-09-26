% Exercise 7.11: DFT of a sampled cosine

addpath('src')
nu_0 = 440;     % cosine frequency [Hz]
nu_s = 2000;    % sampling frequency [Hz]
Dt = 1;         % duration [s]

N_s = round(nu_s * Dt);
t = (0:N_s-1) / nu_s;
f = cos(2*pi*nu_0*t);
F = fft(f);
nu = (0:N_s-1) / Dt;    % the bins are 1/Dt apart

new_figure();
plot(nu, abs(F))
title('DFT of the cosine')
xlabel('Frequency [Hz]')
ylabel('|F|')
grid on
exportgraphics(gcf, 'figures/ex7_11_cosine/raw_dft.png', 'Resolution', 200)

% put 0 Hz in the middle
nu_shifted = ((0:N_s-1) - floor(N_s/2)) / Dt;
new_figure();
plot(nu_shifted, abs(fftshift(F)))
title('Centred DFT')
xlabel('Frequency [Hz]')
ylabel('|F|')
grid on
exportgraphics(gcf, 'figures/ex7_11_cosine/centred_dft.png', 'Resolution', 200)

% the signal is real, so the positive half is enough
half = 1:floor(N_s/2)+1;
new_figure();
plot(nu(half), abs(F(half)))
title('Positive half of the DFT')
xlabel('Frequency [Hz]')
ylabel('|F|')
grid on
exportgraphics(gcf, 'figures/ex7_11_cosine/positive_half_dft.png', 'Resolution', 200)
