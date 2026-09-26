function fig = new_figure(varargin)
% NEW_FIGURE figure() with a white background. Newer MATLAB versions can
% draw figures dark, and exportgraphics keeps that, so force light.

fig = figure('Color', 'w', varargin{:});
if isprop(fig, 'Theme')
    theme(fig, 'light');
end
end
