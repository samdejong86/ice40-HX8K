# Project setup

# Top level entity
PROJ = music_top

MUSIC1=./music-files/tetris.notes
MUSIC2=./music-files/lotz.notes
MUSIC3=./music-files/mario.notes
MUSIC4=./music-files/underground.notes

ALL_MUSIC=$(MUSIC1)
ALL_MUSIC+=$(MUSIC2)
ALL_MUSIC+=$(MUSIC3)
ALL_MUSIC+=$(MUSIC4)

MUSICMIF=$(patsubst %.notes,%.mif,$(wildcard $(ALL_MUSIC)))

indicies = $(shell seq $(words $(MUSICMIF)))
MIFGENERICS = $(foreach x,$(indicies), -gMUSIC_FILE_$(x)=$(word $(x),$(MUSICMIF)))

# Pin constraints
PINS = ../common/iceFUN.pcf

# VHDL files in dependancy order
VHDL=../common/ledscan.vhd
VHDL+=../common/useful_package.vhd
VHDL+=led_animate.vhd
VHDL+=note_counter.vhd
VHDL+=play_tune.vhd
VHDL+=music_top.vhd

GHDL=$(patsubst %.vhd, %.ghd, $(VHDL))

# Use GHDL module for yosys
MODULE=-m ghdl

.PHONY: iceFUN clean burn

%.mif : %.notes
	python songWriter.py $(basename $@).notes

%.ghd: %.vhd
	echo $(basename $@).vhd
	ghdl -a --std=08 -fsynopsys $(basename $@).vhd

all: icePack


# synthesize using Yosys
synthesis: $(GHDL) $(MUSICMIF)
	yosys $(MODULE) -p 'ghdl --std=08 $(MIFGENERICS) -fsynopsys $(PROJ); synth_ice40 -json $(PROJ).json'

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
