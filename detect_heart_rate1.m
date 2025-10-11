function bpm = detect_heart_rate1(ecg, fs)

    % Maybe normalize, doesn't look too good i think. Perform xcorr, test coeff
    %ecg_signal = ecg_signal - mean(ecg_signal); % optional
    [r, lags] = xcorr(ecg); % , 'coeff', see page 336 in textbook

    % Make min/max heart rate range
    min_bpm = 40;
    max_bpm = 180;
    min_lag = floor(fs * 60 / max_bpm); %167 min lag where we could expect to see repeating heartbeats
    max_lag = ceil(fs * 60 / min_bpm); %750 max lag where we could expect to see repeating heartbeats

    % Find of zero lag
    zero_i = find(lags == 0);

    % Search for local maximum after zero lag
    search_range = r(zero_i + min_lag : zero_i + max_lag); % search our lags we believe to be repeating

    [~, peak_i] = max(search_range);

    peak_lag = peak_i + min_lag - 1;

    % Find bpm
    bpm = 60 * fs / peak_lag;

    figure;
    plot(lags/fs, r); % x-axis in seconds
    hold on;
    xline(peak_lag/fs, 'r'); % Draw line at local max
    xlabel('Lag \tau (seconds)');
    ylabel('Autocorrelation');
    title(['Estimated Heart Rate: ', num2str(round(bpm)), ' BPM']); % Have BPMs in title 
    grid on;
    legend('Autocorrelation signal', 'First local max after global max');

    figure;
    plot(lags/fs, r); % x-axis in seconds
    hold on;
    xline(peak_lag/fs, 'r');
    xlabel('Lag \tau (seconds)');
    ylabel('Autocorrelation');
    title(['Near zero lag zoomed']);
    grid on;
    xlim([-0.1 0.3]);
    legend('Autocorrelation signal', 'First local max after global max');

    figure;
    plot(lags/fs, r); % x-axis in seconds
    hold on;
    xline(peak_lag/fs, 'r');
    xlabel('Lag \tau (seconds)');
    ylabel('Autocorrelation');
    title(['First peak zoomed']);
    grid on;
    xlim([0.2 1.7]);
    legend('Autocorrelation signal', 'First local max after global max');
end