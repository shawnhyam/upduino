# Makefile to build UPduino v3.0 rgb_blink.v  with icestorm toolchain
# Original Makefile is taken from: 
# https://github.com/tomverbeure/upduino/tree/master/blink
# On Linux, copy the included upduinov3.rules to /etc/udev/rules.d/ so that we don't have
# to use sudo to flash the bit file.
# Thanks to thanhtranhd for making changes to thsi makefile.

siren.bin: siren.asc
	icepack siren.asc siren.bin

siren.asc: siren.json ../common/upduino.pcf
	nextpnr-ice40 --up5k --package sg48 --json siren.json --pcf ../common/upduino.pcf --asc siren.asc   # run place and route

siren.json: siren.v
	yosys -q -p "synth_ice40 -json siren.json" siren.v

.PHONY: flash
flash:
	iceprog -d i:0x0403:0x6014 siren.bin

.PHONY: clean
clean:
	$(RM) -f siren.json siren.asc siren.bin
