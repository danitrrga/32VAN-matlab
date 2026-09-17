% clear; close all; clc;

path = "Part 1 - Signals/MATLAB/data/van_aartsen.jpg";

f_raw = imread(path);

% imread loads the image in format uint8
% to avoid problems with the fourier we convert to decimals
f = double(f_raw);

[M, N] = size(f);

F = fft2(f);

F_centered = fftshift(F);
F_log = log(1 + abs(F_centered));

