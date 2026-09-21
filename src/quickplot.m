function fig = quickplot(data, plot_title, save_path, xlab, ylab, xdata, ydata)
% QUICKPLOT Plot a matrix as an image and optionally save the figure.
%
%   quickplot(DATA, TITLE)
%   quickplot(DATA, TITLE, SAVE_PATH)
%   quickplot(DATA, TITLE, SAVE_PATH, XLABEL, YLABEL)
%   quickplot(DATA, TITLE, SAVE_PATH, XLABEL, YLABEL, XDATA, YDATA)
%
% DATA is plotted exactly as supplied. Any preprocessing, such as
% log(1 + abs(fftshift(data))), belongs in the calling script.
%
% XLABEL/YLABEL let you put units on the axes (e.g. 'k_x [rad/pixel]'
% for a spectrum plot). XDATA/YDATA let you pass real coordinate values
% instead of plain pixel indices, e.g. the kx/ky frequency vectors.

if nargin < 2
    plot_title = 'Quick Plot';
end
if nargin < 3
    save_path = '';
end
if nargin < 4
    xlab = 'x';
end
if nargin < 5
    ylab = 'y';
end
if nargin < 6
    xdata = 1:size(data, 2);
end
if nargin < 7
    ydata = 1:size(data, 1);
end

fig = figure('Name', plot_title, 'Color', 'w');
imagesc(xdata, ydata, data);
axis image;
colormap gray;
colorbar;
xlabel(xlab);
ylabel(ylab);
title(plot_title, 'Interpreter', 'none');

if ~isempty(save_path)
    output_folder = fileparts(save_path);
    if ~isempty(output_folder) && ~isfolder(output_folder)
        mkdir(output_folder);
    end
    exportgraphics(fig, save_path, 'Resolution', 200);
end
end
