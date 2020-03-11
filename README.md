# Phase-Locking Value - Modulation Index
Matlab routines to assess the modulation of the phase synchronization of faster oscillations by the phase of slower rhythms,  as described in Gonzalez et al. (2020) "Communication through coherence by means of cross-frequency coupling". https://doi.org/10.1101/2020.03.09.984203

## plv_modindex_manager.m
To start, run the plv_modindex_manager.m. The first sub-routine loads the example recording (example_plv_modindex.mat) and computes the PLV comodulogram as described in Gonzalez et al. (2020). The example data includes 3 LFPs sampled at 1024 Hz, which have strong modulation of fast-gamma synchronization by the phase of theta. These routines use the function eegfilt.m from the EEGLab Toolbox (Delorme & Makeig, J Neurosci Methods 2004).

## plv_modindex.m
The routine described above calls the core function plv_modindex.m, which receives as inputs two fast frequency phase time-series, one slow frequency phase time-series, and an integer stating the number of phase bins for the slow frequency. It outputs the Modulation Index from the PLV-phase distribution. For a definition of the Modulation Index and thorough description, see Tort et al., J Neurophysiol 2010.

### Author
Joaquin Gonzalez, 2020.
(Supervision: Adriano Tort)
