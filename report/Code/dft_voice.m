% Exercise 7.13: power spectrum, base frequency and envelope (formants)
% of three voice recordings.

% ---- constants ----
names = {'u_low', 'u_high', 'a_low'};  % recordings in data/voice/
nu_min = 60;                    % lowest base frequency searched for [Hz]
nu_max = 500;                   % highest base frequency searched for [Hz]
nu_plot_max = 3000;             % upper limit of the plotted range [Hz]

% folders relative to this script, so it runs from any current folder
script_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(script_dir, '..'));  % helpers in src/
data_dir = fullfile(script_dir, '..', '..', 'data', 'voice');
fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex7_13_voice');
if ~isfolder(fig_dir)
    mkdir(fig_dir);
end

for i_file = 1:numel(names)
    name = names{i_file};

    % read the recording; keep the first channel if it is stereo
    [f, nu_s] = audioread(fullfile(data_dir, [name '.wav']));  % [-], [Hz]
    f = f(:, 1);
    N_s = length(f);            % number of samples [-]

    % power spectrum and frequency of each bin nu_k = k*nu_s/N_s [Hz]
    F = fft(f);
    P = abs(F).^2;
    nu = (0:N_s-1)' * nu_s / N_s;

    % rough base frequency: the IDFT of the power spectrum is the
    % autocorrelation of f, which peaks at a lag of one period. Search the
    % lags that correspond to nu_max down to nu_min [samples].
    R = real(ifft(P));
    lags = round(nu_s/nu_max) : round(nu_s/nu_min);
    [~, i_lag] = max(R(lags + 1));
    nu_est = nu_s / lags(i_lag);

    % refine: the highest spectral peak within nu_est/2 of the estimate
    near = abs(nu - nu_est) < nu_est/2;
    nu_near = nu(near);
    [~, i_peak] = max(P(near));
    nu_0 = nu_near(i_peak);
    fprintf('%s: base frequency %.1f Hz\n', name, nu_0);

    % envelope: moving average of log10(P) over one harmonic spacing nu_0
    env = 10.^movmean(log10(P), round(nu_0 * N_s / nu_s));

    low = nu <= nu_plot_max;
    new_figure();
    semilogy(nu(low), P(low));
    hold on;
    semilogy(nu(low), env(low), 'k', 'LineWidth', 1.5);
    hold off;
    title(['Power spectrum of ', name, '.wav'], 'Interpreter', 'none');
    xlabel('Frequency \nu [Hz]');
    ylabel('Power |F|^2 [arb. units]');
    legend('|F|^2', 'envelope');
    grid on;
    exportgraphics(gcf, fullfile(fig_dir, [name '_spectrum.png']), 'Resolution', 200);
end
