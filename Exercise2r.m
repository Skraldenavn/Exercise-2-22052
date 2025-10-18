% Load
data = load('ecg.mat');  
ecg = data.ecg;

% Setting parameters used for most/all questions
fs = 500;         
M = length(ecg);
t = (0:M-1)/fs;  

% Q1
% Design a more realistic filter without matlab masking
r = 0.99;              % pole radius 
b = [1 -1];            
a = [1 -r];            

% Apply
ecg1 = filter(b, a, ecg);

% FFTs to show in plot that it is working
ecg_fft = manualfft(ecg, M);
ecg1_fft = manualfft(ecg1, M);

% Frequency vector
f = (0:M-1) * fs / M;

figure;
plot(f, abs(ecg_fft)); hold on;
plot(f, abs(ecg1_fft));
xlabel('Freq (Hz)');
ylabel('Magnitude');
title('Frequency domain before and after filtering');
grid on;
xlim([0 55]);
legend('Before filter','After filter');

% Time domain
figure;
plot(t, ecg); hold on;
plot(t, ecg1);
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Raw ECG and filtered ECG (low freqs suppressed)');
grid on;
xlim([0 1]);
ylim([-0.1 0.8]);
legend('Raw','Filtered');

% Filter magnitude
[H, w] = freqz(b, a, 1024, fs);
figure;
plot(w, abs(H));
title('Magnitude response of manual high-pass filter');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 50]);
grid on;

% Impulse
h1 = impz(b, a, 200);
figure;
stem(h1);
title('Impulse response of manual high-pass filter');
xlabel('Samples');
ylabel('Amplitude');
grid on;

% Q2
% have to make notch filter more realistic, so cannot use matlab masking. use poles and zeros
% And use ecg1 instead of ecg i think?
f0 = 50;         % Frequency we notch at
r = 0.95;        % Pole radius (controls notch width)
o0 = 2*pi*f0/fs; % Placing

% Zeros and poles
b = [1 -2*cos(o0) 1];         % Zeros on unit circle at ±omega0
a = [1 -2*r*cos(o0) r^2];     % Poles inside unit circle at ±omega0

% Apply 
ecg2 = filter(b, a, ecg1); % using ecg1 instead so baseline wander is removed

% FFT to plot
% ecg_fft = manualfft(ecg1, M);
ecg2_fft = manualfft(ecg2, M);

% Plots
f = (0:M-1) * fs / M;

figure;
plot(f, abs(ecg_fft)); hold on; % compare to raw ecg or ecg1?
plot(f, abs(ecg2_fft));
xlabel('Freq (Hz)');
ylabel('Magnitude');
title('Frequency domain before and after filtering');
grid on;
legend('Before','After');
xlim([0 100]);
ylim([0 50]);

% Time domain
figure;
plot(t, ecg); hold on;
plot(t, ecg2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original ECG and 50 Hz Notch filtered signal');
grid on;
legend('Raw','Filtered');
xlim([0 1]);

% use freqz to find frequency response which has amplitude and angle as requested in review
[H, w] = freqz(b, a, 1024, fs);

% Plot filter amplitude and phase
figure;
plot(w, abs(H));
title('Amplitude response of 50 Hz notch filter');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 100]);
grid on;

figure;
plot(w, rad2deg(angle(H))); % Normally seen in degrees i suppose
title('Phase response of 50 Hz notch filter');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
xlim([0 100]);
grid on;

% Q3
Fc = 30; % Set cutoff

% Make filter but i dont know if this kind of filter masking is still allowed? 
% Cause its ideal. They did not comment on it at all though so i guess its fine
H3 = zeros(M,1);
% Many troubles coding this, right part of OR necessary for proper inverse later
H3(f <= Fc | f >= (fs - Fc)) = 1; 


%ecg3_fft = ecg_fft .* H3; % apply

% using ecg2 which has baseline wander filtered and 50 hz notch
ecg3_fft = manualfft(ecg2,M) .* H3; 

figure;
plot(f, abs(ecg_fft)); hold on;
plot(f, abs(ecg3_fft));
xlabel('Freq (Hz)');
ylabel('Magnitude');
title('Frequency domain before and after filtering');
grid on;
legend('Before', 'After');
xlim([0 100]);
ylim([0 50]);

ecg3 = real(manualifft(ecg3_fft, M)); % Back to time

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
%detect_heart_rate1(ecg1, fs);
%detect_heart_rate1(ecg2, fs);
detect_heart_rate1(ecg3, fs);

