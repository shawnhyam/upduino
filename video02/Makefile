# configuration
SHELL = /bin/sh
FPGA_PKG = sg48
FPGA_TYPE = up5k
PCF = upduino.pcf

# included modules
#PATH_LIB = ../../../lib
#ADD_SRC = ${PATH_LIB}/clock/ice40/clock_gen_480p.sv
#ADD_SRC += ../simple_display_timings_480p.sv
ADD_SRC = clock_gen_480p.sv simple_display_timings_480p.sv

#top_bounce: top_bounce.rpt top_bounce.bin
#top_beam: top_beam.rpt top_beam.bin
#top_square: top_square.rpt top_square.bin
video02: video02.rpt video02.bin

%.json: %.sv $(ADD_SRC)
	yosys -ql $(subst .json,,$@)-yosys.log -p 'synth_ice40 -top $(subst .json,,$@) -json $@' $< $(ADD_SRC)

%.asc: %.json
	nextpnr-ice40 --${FPGA_TYPE} --package ${FPGA_PKG} --json $< --pcf ${PCF} --asc $@

%.rpt: %.asc
	icetime -d ${FPGA_TYPE} -mtr $@ $<

%.bin: %.asc
	icepack $< $@

prog:
	iceprog -d i:0x0403:0x6014 video02.bin

clean:
	rm -f *.json *.asc *.rpt *.bin *yosys.log

all: video02

.PHONY: all clean prog
