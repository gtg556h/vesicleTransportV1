function [X,freq]=positiveFFT(x,Fs)
N=length(x); %get the number of points
k=0:N-1;     %create a vector from 0 to N-1
T=N/Fs;      %get the frequency interval
freq=k/T;    %create the frequency range [Hz]
X=fft(x)/N; % normalize the data

% Multiply by 2, because we dropped half the energy by looking only at
% positive half
X = X.*2;

%only want the first half of the FFT, since it is redundant
cutOff = ceil(N/2);

%take only the first half of the spectrum
X = X(1:cutOff);
freq = freq(1:cutOff);