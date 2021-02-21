# Original Makefile is taken from: 
# https://github.com/tomverbeure/upduino/tree/master/blink
# On Linux, copy the included upduinov3.rules to /etc/udev/rules.d/ so that we don't have
# to use sudo to flash the bit file.
# Thanks to thanhtranhd for making changes to thsi makefile.

waveform.bin: waveform.asc
	icepack waveform.asc waveform.bin

waveform.asc: waveform.json ../common/upduino.pcf
	nextpnr-ice40 --up5k --package sg48 --json waveform.json --pcf ../common/upduino.pcf --asc waveform.asc   # run place and route

waveform.json: waveform.v
	yosys -q -p "synth_ice40 -json waveform.json" waveform.v

.PHONY: flash
flash:
	iceprog -d i:0x0403:0x6014 waveform.bin

.PHONY: clean
clean:
	$(RM) -f waveform.json waveform.asc waveform.bin
