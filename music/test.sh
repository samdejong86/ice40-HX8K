#ghdl -a -fsynopsys ledscan.vhd
#ghdl -a -fsynopsys top.vhd
yosys $MODULE -p 'ghdl -fsynopsys top; synth_ice40 -json top.json'
nextpnr-ice40 --hx8k --pcf iceFUN.pcf --asc top.asc --json top.json --opt-timing --package cb132 -r
icepack top.asc top.bin
