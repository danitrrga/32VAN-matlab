function quickplot(data, plot_title)
% QUICKPLOT, plot a 2D spatial image or 2D Fourier spectrum

% Default title if not provided
if nargin < 2
    plot_title = 'Quick Plot';
end

figure('Name', plot_title);

% Check whether data is complex (Fourier spectrum) or real (spatial image)
if ~isreal(data)
    % Fourier spectrum: center origin with fftshift and use logarithmic scale
    spectrum_log = log(1 + abs(fftshift(data)));
    imagesc(spectrum_log);
    colormap(gray); % or colormap(jet) for thermal view
    colorbar;
    xlabel('k_x [frequency index]');
    ylabel('k_y [frequency index]');
else
    % Standard 2D spatial image
    imagesc(data);
    colormap(gray);
    xlabel('x [pixels]');
    ylabel('y [pixels]');
end

axis image; % preserve aspect ratio
title(plot_title);
end
