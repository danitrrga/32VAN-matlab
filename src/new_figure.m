function fig = new_figure(varargin)
% NEW_FIGURE Open a figure with a white background for the report.
%
%   fig = new_figure(NAME, VALUE, ...)
%
% Arguments are passed on to FIGURE. Since R2025a MATLAB may draw figures
% in a dark theme, which exportgraphics keeps; force the light theme where
% the Theme property exists.

fig = figure('Color', 'w', varargin{:});
if isprop(fig, 'Theme')
    theme(fig, 'light');
end
end
