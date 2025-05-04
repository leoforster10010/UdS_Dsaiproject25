% Modell AOM Spektrum

clear % löscht alle Variablen
clc % löscht das Kommandofenster
%close all % schließt alle vorherigen Plots
set(0,'DefaultFigureWindowStyle','docked'); % alle Plots als Tabs in einem Fenster
format compact

% Zeit in µs, Frequenz in MHz
% Modell: Träger ist phasenmoduliert (FM) mit diversen Tönen

dt=1e-3; % Sampling interval
L=1e5; % Zahl der sampling Punkte
t=(0:(L-1))*dt; % Zeitachse
fs=1/dt; % sampling Frequenz = 2 * höchste Frequenz / samples per second (MHz)
df=fs/L; % Frequenzauflösung = sampling Frequenz (MHz)
f=(0:L/2-1)*df;

f0=100; % Trägerfrequenz 
dfm=0.1; % Frequenzauflösung der Modulation (!)
Nm=200; % Zahl der Modulationsfrequenzen
ffm=(1:Nm)*dfm; % FM-Frequenzen außer Null
an=zeros(size(ffm)); % sin-Amplituden
bn=zeros(size(ffm)); % cos-Amplituden

% non-zero spectral components außer Null
% Indizes in an, bn sind Frequenzen in MHz
%an([1,2,3]/dfm)=[0.2,0,0]; fignr=4;
%an([1,2,3]/dfm)=[0,0.2,0]; fignr=5;
%an([1,2,3]/dfm)=[0,0,0.2]; fignr=6;
an([1,2,3]/dfm)=[0.3,0.3,-0.3]; fignr=7;
bn([1,2,3]/dfm)=[0.3,-0.3,0.3];

FM=zeros(size(t));
for nf=1:length(ffm)
    FM=FM+an(nf)*cos(2*pi*ffm(nf)*t)+bn(nf)*sin(2*pi*ffm(nf)*t);
end
RF=cos(2*pi*(f0*t+FM));

figure(1); plot(t,FM)
figure(2); plot(t,RF)

spekFM=fft(FM)/(L/2);
%figure(30); plot(abs(spekFM))
aspekFM=real(spekFM(1:end/2));
bspekFM=imag(spekFM(1:end/2)); % Minuszeichen?
figure(3); plot(f,aspekFM,f,bspekFM)
axis([0 50 -1 1])

spekRF=fft(RF)/(L/2);
%figure(40); plot(abs(spekRF))
aspekRF=real(spekRF(1:end/2));
bspekRF=imag(spekRF(1:end/2)); % Minuszeichen?
figure(fignr); plot(f,aspekRF,f,bspekRF)
axis([50 150 -1 1])