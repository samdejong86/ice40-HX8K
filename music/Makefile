# Project setup

# Top level entity
PROJ = music_top

MUSIC=./music-files/tetris.notes
MUSICMIF=$(patsubst %.notes,%.mif,$(wildcard $(MUSIC)))

# Pin constraints
PINS = iceFUN.pcf

# VHDL files in dependancy order
VHDL=ledscan.vhd
VHDL+=led_animate.vhd
VHDL+=note_counter.vhd
VHDL+=play_tune.vhd
VHDL+=music_top.vhd

GHDL=$(patsubst %.vhd, %.ghd, $(VHDL))

# Use GHDL module for yosys
MODULE=-m ghdl

.PHONY: iceFUN clean burn

%.ghd: %.vhd
	ghdl -a -fsynopsys  $(basename $@).vhd
	@touch $@

all: icePack

$(MUSICMIF):
	python songWriter.py $(MUSIC)

# synthesize using Yosys
synthesis: $(GHDL) $(MUSICMIF)
	yosys $(MODULE) -p 'ghdl -gMUSIC_FILE=$(MUSICMIF) -fsynopsys $(PROJ); synth_ice40 -json $(PROJ).json'

# Place and route using nextpnr
pnr: synthesis
	nextpnr-ice40 -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --opt-timing --pcf $(PINS)

# Convert to bitstream using IcePack
icePack: pnr
	icepack $(PROJ).asc $(PROJ).bin

# Program the board
burn:
	iceFUNprog $(PROJ).bin

clean:
	rm -f *.asc ./music-files/*.mif *.cf *.ghd *.json *.bin
