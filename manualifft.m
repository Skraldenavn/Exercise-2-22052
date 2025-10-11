function sig = manualifft(ft, M)
    % Comments about the file.
    % This is printed if you type: help <function_name>
    % Performs Inverse Fourier Transform, designed for use in code, not executed in terminal.
    %
    % In console run with: 
    % sig = manualifft(ft,M);
    % You need to define ft, M beforehand
    %
    % Output:
    % sig                     - IFFT of signal

    % Generally very similar to manualfft() function.

    len = length(ft);
    V = zeros(size(ft));

    if len < M
        ft = [ft, zeros(1, M - len)];
    else
        ft = ft(1:M);
    end

    for i = 1:length(ft)
        for e = 1:length(ft)
            V(i) = V(i) + ft(e) * exp(1i * 2 * pi * (i-1) * (e-1) / M); % sign flipped
        end
    end

    sig = V / M;  % Normalize by M to complete IFFT
end