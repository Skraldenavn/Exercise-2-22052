function ft = manualfft(sig, M)
    % Comments about the file.
    % This is printed if you type: help <function_name>
    % Performs Fourier Transform, designed for use in code, not executed in terminal.
    % It is called manualfft because its intention is to replace use of matlabs built-in fft().
    %
    % In console run with: 
    % ft = manualfft(signal,M);
    % You need to define signal, M beforehand
    %
    % Output:
    % ft                     - DFT of signal

    len = length(sig); % Find length of signal

    % Ensuring length of M
    if len < M
        sig = [sig, zeros(1,M-len)];
    else
        sig = sig(1:M);
    end

    V = zeros(size(sig)); % Make empty arr size of signal

    % Nested loop through signal
    for i = 1:length(sig) % Loops bins
        for e = 1:length(sig) % Loops samples
            V(i)=V(i)+sig(e)*exp(-1i*2*pi*(i-1)*(e-1)/M); % Assign through each iteration to empty arr
        end
    end

    % if mod(M,2) == 0
    %     ft = [V(M/2+1:end), V(1:M/2)];
    % else
    %     ft = [V((M+1)/2:end), V(1:(M-1)/2)];
    % end

    % if mod(M,2) == 0
    %     ft = [V(M/2+1:end), V(1:M/2)];
    % else
    %     ft = [V((M+1)/2+1:end), V(1:(M+1)/2)];
    % end

    ft = V; % Assign V as output








