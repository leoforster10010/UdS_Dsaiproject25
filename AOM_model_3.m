% Modell AOM Spektrum

clear % löscht alle Variablen
clc % löscht das Kommandofenster
%close all % schließt alle vorherigen Plots
set(0,'DefaultFigureWindowStyle','docked'); % alle Plots als Tabs in einem Fenster
format compact

% Zeit in µs, Frequenz in MHz
% Modell: Träger ist amplitudenmoduliert (AM) mit diversen Tönen

dt=1e-3; % sampling interval
L=1e5; % Zahl der sampling Punkte
t=(0:(L-1))*dt; % Zeitachse
fs=1/dt; % sampling Frequenz = 2 * höchste Frequenz
df=fs/L; % Frequenzauflösung = sampling Frequenz / L
f=(0:L/2-1)*df;

f0=100; % Mittenfrequenz 
dfm=0.1; % Frequenzauflösung der Modulation (!)
Nm=200; % Zahl der Modulationsfrequenzen
fm=f0+(-Nm/2:Nm/2)*dfm; % alle Modulationsfrequenzen
an=zeros(size(fm)); % sin-Amplituden
bn=zeros(size(fm)); % cos-Amplituden

% non-zero spectral components
freq=[98,99,100,101,103]; % Frequenzen zum AWG, müssen in fm enthalten sein
% aus den Frequenzen in MHz werden die Indizes von an, bn berechnet
vec=1+Nm/2+(freq-f0)/dfm; % Indizes der Frequenzen in fm
an(vec)=[1,1,1,0,1]; fignr=7;

AM=zeros(size(t));
for nnf=1:length(vec)
    nf=vec(nnf);
    AM=AM+an(nf)*cos(2*pi*fm(nf)*t)-bn(nf)*sin(2*pi*fm(nf)*t);
end
RF=sin(AM).^3;

figure(1); plot(t,AM)
figure(2); plot(t,RF)

spekAM=fft(AM)/(L/2);
aspekAM=real(spekAM(1:end/2));
bspekAM=imag(spekAM(1:end/2));
figure(3); plot(f,aspekAM,f,bspekAM)
axis([50 150 -1.1 1.1])

spekRF=fft(RF)/(L/2);
aspekRF=real(spekRF(1:end/2));
bspekRF=imag(spekRF(1:end/2));
figure(fignr); plot(f,aspekRF,f,bspekRF)
axis([50 150 -0.4 0.4])