# Project setup

# Top level entity
PROJ = vga_top


# Pin constraints
PINS = iceFUN.pcf

# VHDL files in dependancy order
VHDL=rom_package.vhd
VHDL+=rom.vhd
VHDL+=simple_480p.vhd
VHDL+=drawImage.vhd
VHDL+=pll.vhd
VHDL+=vga_top.vhd

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
