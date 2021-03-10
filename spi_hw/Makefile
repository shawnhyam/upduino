filename = top
pcf_file = ../common/io.pcf

build:
	yosys -q -p "synth_ice40 -json $(filename).json" $(filename).v
# yosys -p "synth_ice40 -blif $(filename).blif" $(filename).v
	nextpnr-ice40 --up5k --package sg48 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc
#    nextpnr -d 5k -P sg48 -p $(pcf_file) $(filename).blif -o $(filename).asc
	icepack $(filename).asc $(filename).bin

prog:
	iceprog -S $(filename).bin

prog_flash:
	iceprog $(filename).bin

clean:
	rm -rf $(filename).blif $(filename).asc $(filename).bin
