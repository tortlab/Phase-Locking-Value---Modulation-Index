%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Phase-locking value - slow phase modulation
% 
% This code applies the method described in Gonzalez et al. (2020) 
% "Communication through coherence by means of cross-frequency coupling".
% https://doi.org/10.1101/2020.03.09.984203
%
% [out] = plv_modindex(fast_phase1,fast_phase2,slow_phase,numbin) 
%
% Inputs: 
%
% fast_phase1: instantaneous fast phase time-series (electrode 1)
% fast_phase2: instantaneous fast phase time-series (electrode 2)
% slow_phase: slow oscillation phase time-series (reference electrode)
% numbin: number of bins of the slow oscillation phase
% 
% Output: 
%
% out: modulation index for the plv-phase distribution
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


function [out] = plv_modindex(fast_phase1,fast_phase2,slow_phase,numbin) 

% Defining the slow oscillation phase bins
position=zeros(1,numbin); % pre-allocating phase bin left boundaries
winsize = 2*pi/numbin; % getting bin width
for j=1:numbin
    position(j) = -pi+(j-1)*winsize; % from -pi to pi-winsize 
end

% Phase-locking value calculation for each phase bin
plv = zeros(numbin,1);
for j=1:numbin % looping through the phase bins
    I = find(slow_phase <  position(j)+winsize & slow_phase >=  position(j)); % selecting the phase time-series of the jth bin
    plv(j) = abs(sum(exp(1i*(fast_phase1(I) - fast_phase2(I))))/length(I)); % calculating the PLV in the jth bin
end

% Getting the modulation index for the PLV
plv_norm = plv./sum(plv); % normalizing the PLV by the sum across bins
Hmax = log(numbin); % maximum entropy
H = -sum(plv_norm(plv_norm>0).*log(plv_norm(plv_norm>0))); % entropy of the normalized PLV-phase distribution
out = (Hmax-H)/Hmax; % normalizing entropy to obtain the Modulation Index 

end

