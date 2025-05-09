# Project setup

# Top level entity
PROJ = keyboard_top


# Pin constraints
PINS = iceFUN.pcf

# VHDL files in dependancy order
VHDL=../common/useful_package.vhd
VHDL+=font4x5_package.vhd
VHDL+=ps2_rx.vhd
VHDL+=keyboard.vhd
VHDL+=key2ascii.vhd
VHDL+=keyboard_top.vhd

GHDL=$(patsubst %.vhd, %.ghd, $(VHDL))

# Use GHDL module for yosys
MODULE=-m ghdl

.PHONY: iceFUN clean burn


%.ghd: %.vhd
	ghdl -a --std=08 -fsynopsys  $(basename $@).vhd

all: icePack


# synthesize using Yosys
synthesis: $(GHDL)
	yosys $(MODULE) -p 'ghdl --std=08 -fsynopsys $(PROJ); synth_ice40 -json $(PROJ).json'

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
