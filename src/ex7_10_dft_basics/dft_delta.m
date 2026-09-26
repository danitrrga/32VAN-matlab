% Exercise 7.10: DFT of a delta peak

addpath('src')
N = 10;             % number of samples

f = zeros(1, N);
f(1) = 1;           % delta at n = 0

F = fft(f)          % should be all ones
f_inv = ifft(F)     % and back to the delta

n = 0:N-1;
k = 0:N-1;
Omega_k = 2*pi*k / N;

new_figure();
subplot(3, 1, 1)
stem(n, f, 'filled')
title('f[n] = \delta[n]')
xlabel('n')
grid on
subplot(3, 1, 2)
stem(Omega_k, abs(F), 'filled')
title('|F|')
xlabel('\Omega_k [rad/sample]')
grid on
subplot(3, 1, 3)
stem(n, real(f_inv), 'filled')
title('ifft(F)')
xlabel('n')
grid on
exportgraphics(gcf, 'figures/ex7_10_dft_basics/dft_delta.png', 'Resolution', 200)
