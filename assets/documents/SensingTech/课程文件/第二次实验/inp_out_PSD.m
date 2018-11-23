%% Read input file
[filename, filepath] = uigetfile('*.wav', 'Select input file...');      % Opens a dialog box so you can choose a wav file
input_file = fullfile(filepath, filename);      % Creates the filename
[inp, Fs] = audioread(input_file);

dt = 1.0/Fs;                                    % Time between discrete samples

%% Filter creation
fc__Hz = 300.0;                         % Cut-off frequency in Hz
tau = 1.0/(2*pi*fc__Hz);
s = tf('s');

% Create transfer function of filter(s)
filt_type_label='1st order RC low-pass filter';          % For plotting purposes
tf_LPF = 1.0/(tau*s + 1.0);               % 1st order RC Low pass filter
d_filt = c2d(tf_LPF, dt);                 % Convert continuous transfer function to discrete

[tf_num, tf_denom] = tfdata(d_filt, 'v'); % Separate into numerator and denominator
outp = filter(tf_num, tf_denom, inp);     % Apply filter


%% Butterworth filter
% As an alternative to creating it with transfer function, 
% you can could create a discrete filter directly filter:
% fc__Hz = 300.0;
% fc_norm = fc__Hz/(Fs/2.0);
% filt_type_label='Butterworth';          % For plotting purposes
% filt_order = 2;
% filt_type = 'low'; 
% [num, denom] = butter(filt_order, fc_norm, filt_type);
% outp = filter(num, denom, inp);

%% Plot results
figure;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.01, 0.9, 0.9]);

% PSD plot for input signal
ax1 = subplot(1,2,1);
[p, f] = pwelch(inp, [], [], [], Fs);
plot(f, p, 'b-');
grid on;
xlabel('Frequency (Hz)');
ylabel('PSD amplitude (V^2/Hz)');
xlim([1 10000]);
set(gca,'TickDir','out'); 
title({'Input PSD', ' '});
improvePlot;

% PSD plot for output signal
ax2 = subplot(1,2,2);
[p, f] = pwelch(outp, [], [], [], Fs);
plot(f, p, 'b-');
grid on;
xlabel('Frequency (Hz)');
ylabel('PSD amplitude (V^2/Hz)');
title({filt_type_label,'Output PSD',' '});
xlim([1 2000]);
improvePlot;
set(gca,'TickDir','out'); 

linkaxes([ax1 ax2], 'xy');

% Clean up all the font-sizes 
% Grab the axes handle(s)
axis_handles=findobj(gcf,'type','axe');

% Iterate over all axes handle(s)
for i = 1:length(axis_handles)
    ax = axis_handles(i);

    % Change font size
    set(ax, 'FontSize', 16)

end
