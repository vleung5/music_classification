#install.packages("tuneR")

library(tuneR)

# define path to audio file
fin = 'C:/Adele - Rolling In The Deep.mp3'

# read in audio file
data = readMP3(fin)

# extract signal
snd = data@left

# determine duration
dur = length(snd)/data@samp.rate
dur # seconds
# [1] 228.3624

# determine sample rate
fs = data@samp.rate
fs # Hz
## [1] 44100

#######################################################################################
#Plot wave

# demean to remove DC offset
snd = snd - mean(snd)

# plot waveform
plot(snd, type = 'l', xlab = 'Samples', ylab = 'Amplitude')

#######################################################################################
#Plot spectrogram

# number of points to use for the fft
nfft=1024

# window size (in points)
window=256

# overlap (in points)
overlap=128

#install.packages("signal")
#install.packages("oce")
library(signal, warn.conflicts = F, quietly = T) # signal processing functions
library(oce, warn.conflicts = F, quietly = T) # image plotting functions and nice color maps

# create spectrogram
spec = specgram(x = snd,
                n = nfft,
                Fs = fs,
                window = window,
                overlap = overlap
)

# discard phase information
P = abs(spec$S)

# normalize
P = P/max(P)

# convert to dB
P = 10*log10(P)

# config time axis
t = spec$t

# plot spectrogram
imagep(x = t,
       y = spec$f,
       z = t(P),
       col = oce.colorsViridis,
       ylab = 'Frequency [Hz]',
       xlab = 'Time [s]',
       drawPalette = T,
       decimate = F
)
