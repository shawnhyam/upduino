VERILOGS = top.v pll.v wave_gen_square.v wave_gen_triangle.v

all: audio02.bin

audio02.bin: $(VERILOGS) ../common/upduino.pcf Makefile
	yosys -q -p "synth_ice40 -json audio02.json" $(VERILOGS)
	nextpnr-ice40 -q --up5k --package sg48 --json audio02.json --pcf ../common/upduino.pcf --asc audio02.asc
	#skipped:# icebox_explain j1a.txt > j1a.ex
	icepack audio02.asc audio02.bin

.PHONY: flash
flash:
	iceprog -d i:0x0403:0x6014 audio02.bin

.PHONY: clean
clean:
	$(RM) -f top.json audio02.asc audio02.bin
