clear;
% physical size (x and y) of the calculation domain [m]
D=2;

% number of points in either direction
N=513;

% spatial sampling 'period' (cell size) in either direction [m]
dx=D/N;
dy=D/N;

% Position (center) and size of the rectangle (in index 'units')
% (the width and height are 2*Lxh+1 and 2*Lyh+1, respectively.
Cx=N/2;
Cy=N/2;
Lxh=2;
Lyh=4;

% width and height of the rectangle [m]
a = (1+Lxh*2)*dx;
b = (1+Lyh*2)*dy;

% arrays that contain the x and y coordinates of the cells
% (x and y axes).
x=(0:N-1)*dx;
y=(0:N-1)*dy;

% create and plot the rectangle f (left figure)
f=zeros(N,N);
f(Cx-Lxh:Cx+Lxh,Cy-Lyh:Cy+Lyh)=1;
colormap('default');
subplot(1,3,1), imagesc(x,y,abs(f));

% now do the spectral stuff:
% spatial wave number resolutions:
dkx=2*pi/D;
dky=2*pi/D;

% wave number values after fftshift.
kx_s = (-N/2:(N-1)/2) * dkx;
ky_s = (-N/2:(N-1)/2) * dky;

%note: multiply with the spatial periods (lengths) to obtain
% (an approximation of) the spectrum of the actual
% 'unsampled' function.
F=dx*dy*fft2(f);
Fsh=fftshift(F);
subplot(1,3,2), imagesc(kx_s,ky_s,abs(Fsh));

% analytical result:

%transpose ky_s to obtain a grid when multiplying
A = a * b * sinc(kx_s * b / (2*pi)) .* sinc(ky_s' * a / (2*pi));

subplot(1,3,3), imagesc(kx_s,ky_s,abs(A));