function ifr = spikes2ifr(spiketimes)
isi = spiketimes(2:end) - spiketimes(1:end-1); % interspike intervals
ifr = [1./isi; 0];