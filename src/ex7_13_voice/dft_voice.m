% Exercise 7.13: spectrum, base frequency and envelope of our recordings

addpath('src')
names = {'u_low', 'u_high', 'a_low'};
nu_min = 60;        % range in which we look for the base frequency [Hz]
nu_max = 500;
nu_plot = 3000;     % plot the spectrum up to this frequency [Hz]

for i = 1:numel(names)
    name = names{i};
    [f, nu_s] = audioread(['data/voice/' name '.wav']);
    f = f(:, 1);
    N_s = length(f);

    F = fft(f);
    P = abs(F).^2;
    nu = (0:N_s-1)' * nu_s / N_s;

    % ifft of the power spectrum is the autocorrelation, which peaks at a
    % lag of one period: first guess for nu_0
    R = real(ifft(P));
    lags = round(nu_s/nu_max) : round(nu_s/nu_min);
    [~, j] = max(R(lags + 1));
    nu_est = nu_s / lags(j);

    % the lag is a whole number of samples, so refine with the strongest
    % peak of the spectrum near the guess
    near = abs(nu - nu_est) < nu_est/2;
    nu_near = nu(near);
    [~, j] = max(P(near));
    nu_0 = nu_near(j);
    fprintf('%s: base frequency %.1f Hz\n', name, nu_0)

    % envelope: average log10(P) over one harmonic spacing
    env = 10.^movmean(log10(P), round(nu_0 * N_s / nu_s));

    low = nu <= nu_plot;
    new_figure();
    semilogy(nu(low), P(low))
    hold on
    semilogy(nu(low), env(low), 'k', 'LineWidth', 1.5)
    hold off
    grid on
    title(name, 'Interpreter', 'none')
    xlabel('Frequency [Hz]')
    ylabel('|F|^2')
    legend('|F|^2', 'envelope')
    exportgraphics(gcf, ['figures/ex7_13_voice/' name '_spectrum.png'], 'Resolution', 200)
end
