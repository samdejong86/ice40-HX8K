# Project setup

# Top level entity
PROJ = seven_segment_top


# Pin constraints
PINS = iceFUN.pcf

# VHDL files in dependancy order
VHDL=../common/ledscan.vhd
VHDL+=../uart/uart_tx_nand.vhd
VHDL+=../uart/uart_rx_nand.vhd
VHDL+=hex2sseg.vhd
VHDL+=secondCounter.vhd
VHDL+=DoubleDabble.vhd
VHDL+=seven_segment_top.vhd

GHDL=$(patsubst %.vhd, %.ghd, $(VHDL))

# Use GHDL module for yosys
MODULE=-m ghdl

.PHONY: iceFUN clean burn


%.ghd: %.vhd
	ghdl -a -fsynopsys --std=08 $(basename $@).vhd

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
