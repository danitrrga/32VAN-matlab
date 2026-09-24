name = 'a_low.wav';
% recordings live in data/voice/, two folders up from this script
data_dir = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'data', 'voice');
[f, nu_s] = audioread(fullfile(data_dir, name));
f = f(:,1);
N_s = length(f);
F = fft(f);
Power = abs(F).^2;
v_k = (0:N_s-1)' * nu_s/N_s;


R = real(ifft(Power));
L = round(nu_s/500) : round(nu_s/60);
[~, i] = max(R(L+1));
nu_0 = nu_s / L(i);
fprintf('Base frequency: %.1f Hz\n', nu_0)
env = 10.^movmean(log10(Power), round(nu_0*N_s/nu_s));


% Plot
low = v_k <= 3000;
semilogy(v_k(low), Power(low))
hold on
semilogy(v_k(low), env(low), 'k', 'LineWidth', 1.5)
hold off
xlabel('Frequency (Hz)')
ylabel('Power |F|^2 (arb. units)')
title(['Power spectrum of ', name], 'Interpreter', 'none')
legend('|F|^2', 'envelope')
