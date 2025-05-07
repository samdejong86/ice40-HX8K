# Project setup

# Top level entity
PROJ = bounce_top


# Pin constraints
PINS = ../common/iceFUN.pcf

# VHDL files in dependancy order
VHDL=../common/ledscan.vhd
VHDL+=led_bounce.vhd
VHDL+=bounce_top.vhd

GHDL=$(patsubst %.vhd, %.ghd, $(VHDL))

# Use GHDL module for yosys
MODULE=-m ghdl

.PHONY: iceFUN clean burn


%.ghd: %.vhd
	ghdl -a -fsynopsys  $(basename $@).vhd

all: icePack


# synthesize using Yosys
synthesis: $(GHDL)
	yosys $(MODULE) -p 'ghdl -fsynopsys $(PROJ); synth_ice40 -json $(PROJ).json'

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
	rm -f *.asc *.cf *.json *.bin
