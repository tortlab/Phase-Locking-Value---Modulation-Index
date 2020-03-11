%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Phase-locking value - slow phase modulation - Manager program
% 
% This program loads and preprocesses all inputs necessary to run 
% the core function plv_modindex.m (Gonzalez et al. 2020, 
% "Communication through coherence by means of cross-frequency coupling"
% https://doi.org/10.1101/2020.03.09.984203)
% 
% We provide an example in the file 'Example_plv_modindex.mat', which contains
% intracranial recordings of a representative animal during REM sleep. The
% file contains 3 time-series: lfp1 corresponds to the right primary
% somatosensory cortex, lfp2 to the left primary somatosensory cortex and
% the lfp_sw corresponds to the right secondary visual cortex which
% contains the theta oscillation picked by volume conduction from the
% hippocampus. 
% 
% The first step is to load the lfps and set the frequencies to analyze. 
% Next, the routine filters the lfps employing the function eegfilt.m (from 
% the open package EEGLAB) and gets the phase time-series applying the
% hilbert transform. These steps get all the inputs needed to run the 
% function plv_modindex.m 
% 
% Additionally, a plotting routine is included in the last block of code,
% which takes the output from plv_modindex.m and plots the comodulogram.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Joaquin Gonzalez, March 2020
% Laboratorio de Neurofisiologia del Sueno
% Facultad de Medicina, Universidad de la Republica, Uruguay.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Load data

clc, clear, clf
load('Example_plv_modindex.mat')


%% Setting Parameters
srate = 1024; % sampling rate 
slow_vector = 0:1:15; % vector of frequencies to filter the slow waves
fast_vector = 40:10:180; % vector of frequencies to filter the fast waves
slow_BandWidth = 4; % filter bandwidth (slow waves)
fast_BandWidth = 20; % filter bandwidth (fast waves)
numbin = 18; % number of phase bins (slow waves) 
data_length = length(lfp1); % getting the length of the lfp time-series

% Pre-allocating 
FastPhase1 = zeros(length(fast_vector), data_length); % pre-allocating
FastPhase2 = zeros(length(fast_vector), data_length); % pre-allocating
SlowPhase = zeros(length(slow_vector), data_length); % pre-allocating

%% Obtaining the fast frequency phase time-series
 for ii=1:length(fast_vector)
    Ff1 = fast_vector(ii); % selecting frequency (low cut)
    Ff2=Ff1+fast_BandWidth; % selecting frequency (high cut) 
    FastFreq1=eegfilt(lfp1',srate,Ff1,Ff2); % filtering lfp1
    FastFreq2=eegfilt(lfp2',srate,Ff1,Ff2); % filtering lfp2
    FastPhase1(ii, :) = angle(hilbert(FastFreq1)); % getting the intantaneous phase of lfp1
    FastPhase2(ii, :) = angle(hilbert(FastFreq2)); % getting the intantaneous phase of lfp2
 end
 
%% Obtaining the slow frequency phase time-series
for jj=1:length(slow_vector)
    Sf1 = slow_vector(jj); % selecting frequency (low cut)
    Sf2 = Sf1 + slow_BandWidth; % selecting frequency (high cut)
    SlowFreq = eegfilt(lfp_sw',srate,Sf1,Sf2); % filtering lfp with the slow wave reference
    SlowPhase(jj, :) = angle(hilbert(SlowFreq)); % getting the intantaneous phase of the slow wave 
end

%% Loop through the frequencies and compute the plv_modindex comodulogram
plv_modindex_comodulogram = zeros(size(FastPhase1,1),size(SlowPhase,1)); % pre-allocating
for i = 1:size(SlowPhase,1) % loop through slow frequencies
    for j = 1:size(FastPhase1,1) % loop through fast frequencies   
        plv_phase_modindex = plv_modindex(FastPhase1(j,:)',FastPhase2(j,:)',SlowPhase(i,:)',numbin); % plv_modindex calculation
        plv_modindex_comodulogram(j,i) = plv_phase_modindex; % storing the results in the variable plv_modindex_comodulogram
    end  
end 

%% Plotting the comodulogram

figure(1)
contourf(slow_vector+slow_BandWidth/2,fast_vector+fast_BandWidth/2,plv_modindex_comodulogram,50,'edgecolor','none')
set(gca,'Fontsize',12)
ylabel('PLV Frequency (Hz)','Fontsize',20)
xlabel('Phase Frequency (Hz)','Fontsize',20)
grid on
set(gca,'gridcolor',[1 1 1],'gridalpha',0.5,'gridlinestyle','--')
h = colorbar;
ylabel(h, 'Mod Index','Fontsize',15)



    
