clc;
clear all;
close all;

% Load ECG signal (replace with your own ECG data)
load('ECGData.mat');
% For 20200105196;LMN=196
% L+N=1+6=7
% 5*(M+N)=5*(9+6)=75

ecg_signal_1=val(7,:);
ecg_signal_2=val(75,:);

% Define ECG Signal Parameter
fs = 500;  % Sampling frequency (in Hz)
N=512;
X1=fft(ecg_signal_1,N);
X2=fft(ecg_signal_2,N);
df=fs/N;
f=-fs/2:df:fs/2-df+df/2*mod(N,2);
t=0:1/fs:20;
t=t(1:length(t)-1);

figure(1)
subplot 311
plot(t,ecg_signal_1,'black')
xlabel('Time(s)')
ylabel('Amplitude(Volt)')
title('ECG Signal-I')
subplot 312
plot(f,abs(fftshift(X1)),'black')
xlabel('Frequency(Hz)')
ylabel('Magnitude Response')
title('Frequency Spectrum')
subplot 313
plot(f,angle(fftshift(X1))*180/pi,'black')
xlabel('Frequency(Hz)')
ylabel('Phase Response')
title('Phase Spectrum')
figure(2)
subplot 311
plot(t,ecg_signal_2,'black')
xlabel('Time(s)')
ylabel('Amplitude(Volt)')
title('ECG Signal-II')
subplot 312
plot(f,abs(fftshift(X2)),'black')
xlabel('Frequency(Hz)')
ylabel('Magnitude Response')
title('Frequency Spectrum')
subplot 313
plot(f,angle(fftshift(X2))*180/pi,'black')
xlabel('Frequency(Hz)')
ylabel('Phase Response')
title('Phase Spectrum')

% Define Filter Parameters
Fs = 1000;           % No. of Points for analysis
Fp = 40;             % Passband frequency (Hz)
Fst = 100;           % Stopband frequency (Hz)
Apass = 0.5;         % Passband ripple (dB)
Astop = 60;          % Stopband attenuation (dB)
transition_width = 20; % Width of the transition band (Hz)
N = ceil(2.55 / (transition_width / Fs)); % Filter order

% Calculate normalized frequencies
wp = 2 * pi * Fp / Fs;
ws = 2 * pi * Fst / Fs;


% Generate Hamming window
kaiser_window = kaiser(N + 1);

% Calculate the ideal impulse response of the low-pass filter
n=[1:length(kaiser_window)-1];
hd = (ws/pi) * sinc(ws*(n - N/2)/pi);

% Apply the window to the ideal impulse response
h = hd.* kaiser_window(1:length(kaiser_window)-1)';

% Apply the filter kernel to the ECG signal using convolution
filtered_ecg_1 = conv(ecg_signal_1, h, 'same');
filtered_ecg_2 = conv(ecg_signal_2, h, 'same');

% Define Frequency Response
[h1,f]=freqz(h,1,1024,Fs);

figure(3)
subplot 311
plot(f(1:length(h1)),20*log10(abs(h1)),'black')
xlabel('Frequency(Hz)')
ylabel('Magnitude Response(dB)')
title('Filter Frequency Response')
subplot 312
plot(f(1:length(h1)),unwrap(angle(h1)),'black');
xlabel('Frequency(Hz)')
ylabel('Phase Respone')
title('Filter Phase Response')
subplot 313
impz(h,1)

% Apply the FIR filter
N1=1000;
df1=Fs/N1;
f=-Fs/2:df1:Fs/2-df1+df1/2*mod(N1,2);
filtered_ecg_1 = filter(h,1,ecg_signal_1);
filtered_ecg_2 = filter(h,1,ecg_signal_2);

Y1=fft(filtered_ecg_1,N1);
Y2=fft(filtered_ecg_2,N1);

figure(4)
subplot 311
plot(t,filtered_ecg_1,'black')
xlabel('Time(s)')
ylabel('Amplitude(Volt)')
title('Filtered ECG Signal-I')
subplot 312
plot(f,abs(fftshift(Y1)),'black')
xlabel('Frequency(Hz)')
ylabel('Magnitude Response')
title('Frequency Spectrum')
subplot 313
plot(f,angle(fftshift(Y1))*180/pi,'black')
xlabel('Frequency(Hz)')
ylabel('Phase Response')
title('Frequency Spectrum')
figure(5)
subplot 311
plot(t,filtered_ecg_2,'black')
xlabel('Time(s)')
ylabel('Amplitude(Volt)')
title('Filtered ECG Signal-II')
subplot 312
plot(f,abs(fftshift(Y2)),'black')
xlabel('Frequency(Hz)')
ylabel('Magnitude Response')
title('Frequency Spectrum')
subplot 313
plot(f,angle(fftshift(Y2))*180/pi,'black')
xlabel('Frequency(Hz)')
ylabel('Phase Response')
title('Frequency Spectrum')