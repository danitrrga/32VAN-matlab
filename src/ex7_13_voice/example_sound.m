% This file demonstrates the recent MATLAB facilities for
% recording and playing sound and reading and writing
% sound files.

% sample frequency [Hz]
Fs = 41000;
% number of bits that are used to represent the sound samples'
nbits = 16;

% create an audiorecorder object
rec = audiorecorder(Fs,nbits,1);

% use the laptop's microphone to record 2 seconds of sound,
% return when finished
recordblocking(rec,2);

% copy the result buffer into an (Ns x 1) matrix f
f = getaudiodata(rec);

% size returns the dimensions of its argument, here [Ns 1].
% the number of samples Ns is equal to the first component
% of this vector
fs = size(f);
Ns = fs(1);

fprintf('Sampling frequency: %d\n',Fs);
fprintf('Number of samples:  %d\n',Ns);

input('Press enter to continue...');

fprintf('Playing the recording...\n');

% play the array f, assume sampling frequency Fs.
% 'sc' stands for 'scaled'.
soundsc(f,Fs);

% write the sound signal f as a WAV file.
% tell the command what sampling frequency (Fs) was used.
audiowrite('myfirstrecording.wav',f,Fs);

% read an existing WAV file.
[f2 Fs2] = audioread('myfirstrecording.wav');

% now f2 is equal to f, Fs2 to Fs.
