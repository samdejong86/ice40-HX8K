# Project setup

# Top level entity
PROJ = music_top

# Pin constraints
PINS = iceFUN.pcf

NOTES=$(patsubst %.notes, %.bin, $(wildcard ./music-files/*.notes))

# VHDL files in dependancy order
VHDL=ledscan.vhd
VHDL+=led_animate.vhd
VHDL+=note_counter.vhd
VHDL+=play_tune.vhd
VHDL+=ROM-test.vhd
VHDL+=music_top.vhd

GHDL=$(patsubst %.vhd, %.ghd, $(VHDL))

# Use GHDL module for yosys
MODULE=-m ghdl

.PHONY: iceFUN clean burn

%.bin: %.notes
	python songWriter.py $(basename $@).notes

%.ghd: %.vhd
	ghdl -a -fsynopsys  $(basename $@).vhd
	@touch $@

iceFUN: $(GHDL) $(NOTES)
	# synthesize using Yosys
	yosys $(MODULE) -p 'ghdl -fsynopsys $(PROJ); synth_ice40 -json $(PROJ).json'
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --opt-timing --pcf $(PINS)
	# Convert to bitstream using IcePack
	icepack $(PROJ).asc $(PROJ).bin

burn:
	iceFUNprog $(PROJ).bin

clean:
	rm -f *.asc ./music-files/*.mif *.cf *.ghd *.json *.bin
