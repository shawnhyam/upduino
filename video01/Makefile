# configuration
SHELL = /bin/sh
FPGA_PKG = sg48
FPGA_TYPE = up5k
PCF = upduino.pcf

# included modules
#PATH_LIB = ../../../lib
#ADD_SRC = ${PATH_LIB}/clock/ice40/clock_gen_480p.sv
#ADD_SRC += ../simple_display_timings_480p.sv
ADD_SRC = clock_gen_480p.sv

#top_bounce: top_bounce.rpt top_bounce.bin
#top_beam: top_beam.rpt top_beam.bin
#top_square: top_square.rpt top_square.bin
video01: video01.rpt video01.bin

%.json: %.sv
	yosys -ql $(subst .json,,$@)-yosys.log -p 'synth_ice40 -top $(subst .json,,$@) -json $@' $< $(ADD_SRC)

%.asc: %.json
	nextpnr-ice40 --${FPGA_TYPE} --package ${FPGA_PKG} --json $< --pcf ${PCF} --asc $@

%.rpt: %.asc
	icetime -d ${FPGA_TYPE} -mtr $@ $<

%.bin: %.asc
	icepack $< $@

clean:
	rm -f top*.json top*.asc top*.rpt top*.bin top*yosys.log

all: video01

.PHONY: all clean
