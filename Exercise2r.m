% Opens many plots when run
% Load
data = load('ecg.mat');  
ecg = data.ecg;

% Setting parameters used for most/all questions
fs = 500;         
M = length(ecg);
t = (0:M-1)/fs;  % Time 

% fft, maybe use manualfft()
ecg_fft = manualfft(ecg, M);
%ecg_fft = manualfft(ecg);

% Freq vector
f = (0:M-1) * fs / M;
% After review of exercise #1 i tested linspace freq vector to correct bins but didnt work well
%f = linspace(-fs/2,fs/2, M); 

% Q1
% Make filter to zero out frequencies at 0.5 Hz and below
H1 = ones(M,1);
H1(f <= 0.5) = 0;
ecg_filt1 = ecg_fft .* H1; % Apply

% Show freq domain
figure;
plot(f, abs(ecg_fft)); hold on;
plot(f, abs(ecg_filt1));
xlabel('Freq (Hz)');
ylabel('Magnitude');
title('Frequency domain before and after filtering');
grid on;
xlim([0 25]);
legend('Before filter','After filter');

% Inverse to time
ecg1 = real(manualifft(ecg_filt1, M));  

% Plot both together in time-domain
figure;
plot(t, ecg); hold on;
plot(t, ecg1);
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Raw ECG and filtered ECG signal (low frequencies removed)');
grid on;
xlim([0 1]);
ylim([-0.1 0.8]);
legend('Raw','Filtered');

% Impulse response
h1 = real(manualifft(H1, M));

% Need this plot? unsure, seems right already
figure;
plot(h1);
title('Impulse response of high-pass filter');
xlabel('Samples');
ylabel('Amplitude');
%xlim([N/2 - 100, N/2 + 100]); % Needs zoom

% Q2
f0 = 50; % Freq to notch at
r = 1; % Width of notch or it will have no effect

% Make filter
H2 = ones(M,1);
%H(f == 50) = 0; % Useless without somw width
H2(abs(f - f0) < r/2) = 0; %range within +- 0.5 of 50 hz
ecg_filt2 = ecg_fft .* H2; % Apply filter

figure;
plot(f, abs(ecg_fft)); hold on;
plot(f, abs(ecg_filt2));
xlabel('Freq (Hz)');
ylabel('Magnitude');
title('Frequency domain before and after filtering');
grid on;
legend('Before', 'After');
xlim([0 100]);
ylim([0 50]); % lots of energy at low frequencies, need zoom in both axes

ecg2 = real(manualifft(ecg_filt2, M));

figure;
plot(t, ecg); hold on;
plot(t, ecg2);
title('Original ECG and Notch filtered signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
legend('Raw ECG','ECG filtered by Notch filter');
xlim([0 1]);

figure;
plot(t, ecg); hold on;
plot(t, ecg2);
title('Original ECG and Notch filtered signal zoomed');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
legend('Raw ECG','ECG signal filtered by Notch filter');
xlim([0.4 0.8]);

% Q3
Fc = 30; % Set cutoff

% Make filter
H3 = zeros(M,1);
% Many troubles coding this, right part of OR necessary for proper inverse later
H3(f <= Fc | f >= (fs - Fc)) = 1; 

% Isn't clear in the questions but maybe i should 
% combine lowpass + highpass filters like shown below? Could also fix autocorrelation function
%ecg_fft1 = manualfft(ecg1, M);
%ecg_filt3 = ecg_fft1 .* H3; % apply

ecg_filt3 = ecg_fft .* H3; % apply

figure;
plot(f, abs(ecg_fft)); hold on;
plot(f, abs(ecg_filt3));
xlabel('Freq (Hz)');
ylabel('Magnitude');
title('Frequency domain before and after filtering');
grid on;
legend('Before', 'After');
xlim([0 100]);
ylim([0 50]);

ecg3 = real(manualifft(ecg_filt3, M)); % Back to time

figure;
subplot(2,1,1);
plot(t, ecg);
title('Original ECG');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, ecg3);
title(['Filtered ECG (fc = ', num2str(Fc), ' Hz)']); % Print cutoff freq on plot
xlabel('Time (s)');
ylabel('Amplitude');


figure;
plot(t, ecg); hold on;
plot(t, ecg3);
title('One period of filtered ECG');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Before', 'After');
xlim([1.6 2.6]); % One period
grid on;

% Q4
detect_heart_rate1(ecg, fs);
detect_heart_rate1(ecg2, fs);
detect_heart_rate1(ecg3, fs);

