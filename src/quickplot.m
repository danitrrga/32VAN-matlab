function fig = quickplot(data, plot_title, save_path)
% QUICKPLOT Plot a matrix and optionally save the resulting figure.
%
%   quickplot(DATA, TITLE)
%   quickplot(DATA, TITLE, SAVE_PATH)
%
% DATA is plotted exactly as supplied. Any preprocessing, such as
% log(1 + abs(fftshift(data))), belongs in the calling script.

if nargin < 2
    plot_title = 'Quick Plot';
end
if nargin < 3
    save_path = '';
end

fig = figure('Name', plot_title, 'Color', 'w');
imagesc(data);
axis image;
colormap gray;
colorbar;
xlabel('x');
ylabel('y');
title(plot_title, 'Interpreter', 'none');

if ~isempty(save_path)
    output_folder = fileparts(save_path);
    if ~isempty(output_folder) && ~isfolder(output_folder)
        mkdir(output_folder);
    end
    exportgraphics(fig, save_path, 'Resolution', 200);
end
end
