
% Read in file
[filename, filepath] = uigetfile('*.wav');     % Opens a dialog box so you can choose a wav file
input_file = fullfile(filepath, filename);         % Creates the filename
[y,Fs] = audioread(input_file);
a=y(:,1);

% compute the psd!
[p, f] = pwelch(a, [], [], [], Fs);

% plot the result!
figure;
plot(f, p);
title('PSD of Noisy Waveform');
axis([0 10000 0 inf]);
xlabel('Frequency (Hz)');
ylabel('Amplitude');




