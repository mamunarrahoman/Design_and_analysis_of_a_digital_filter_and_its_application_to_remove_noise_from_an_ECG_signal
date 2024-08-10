clc;
clear all;
close all;

f1=40;
f2=143;
f3=162;
f4=80;

fs=5000; %samplig Frequency>=2*f
ts=1/fs;
t0=0.3;
t=-t0/2:ts:t0/2;
% Input Signal
signal=sin(2*pi*f1*t)+sin(2*pi*f2*t)+sin(2*pi*f3*t)+sin(2*pi*f4*t);

N=256;
df=fs/N;
% Fast Fourier Transform
X=fft(signal,N);
f=-fs/2:df:fs/2-df+df/2*mod(N,2);

figure(1)
subplot 311
plot(t,signal,'black')
xlabel('Time(s)')
ylabel('Amplitude(Volt)')
title('Given Signal')
subplot 312
stem(f,abs(fftshift(X)),'black')
xlabel('Frequency(Hz)')
ylabel('Magnitude Response')
title('Magnitude Spectrum')
subplot 313
stem(f,angle(fftshift(X))*180/pi,'black')
xlabel('Frequency(Hz)')
ylabel('Phase Response')
title('Phase Spectrum')

bw=10;
w=2*pi*f2/fs;
r=1-(bw/fs)*pi;

zeros=[exp(1j*w) exp(-1j*w)];
poles=[r*exp(1j*w) r*exp(-1j*w)];

a=poly(zeros);
b=poly(poles);

% Frequency Response
[h,f]=freqz(a,b,512,fs);

figure(2)
subplot 311
plot(f,abs(h)/max(abs(h)),'black')
xlabel('Frequency(Hz)')
ylabel('Magnitude Response')
title('Frequency Response of designed Filter')
subplot 312
plot(f,angle(h)*180/pi,'black')
xlabel('Frequency(Hz)')
ylabel('Phase Response')
title('Frequency Response of designed Filter')
subplot 313
impz(a,b,50);

% Applying Filter
N1=256;
df1=fs/N1;
f1=-fs/2:df1:fs/2-df1+df1/2*mod(N1,2);
filtered_signal = filter(a,b,signal);
Y = fft(filtered_signal,N1);

figure(3)
subplot 311
plot(t, filtered_signal,'black')
xlabel('Time(s)')
ylabel('Amplitude(Volt)')
title('Filtered Signal')
subplot 312
stem(f1,abs(fftshift(Y)),'black')
xlabel('Frequency(Hz)')
ylabel('Magnitude Response')
title('Magnitude Spectrum')
subplot 313
stem(f1,angle(fftshift(Y))*180/pi,'black')
xlabel('Frequency(Hz)')
ylabel('Phase Response')
title('Magnitude Spectrum')