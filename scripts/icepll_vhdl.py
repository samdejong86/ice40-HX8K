#!/usr/bin/env python
import argparse
import subprocess

parser = argparse.ArgumentParser(description='Generate a VHDL entity using icepll')

parser.add_argument('-i', '--input', help='PLL Input Frequency (default: 12 MHz)', default=12, required=False)
parser.add_argument('-o', '--output', help='PLL Output Frequency (default: 60 MHz)', default=60, required=False)
parser.add_argument('-p', '--primitive', help='Use SB_PLL40_PAD primitive instead of SB_PLL40_CORE', action='store_true', required=False)
parser.add_argument('-S', '--disableSimple', help='Disable SIMPLE feedback path mode', action='store_true', required=False)
parser.add_argument('-b', '--best', help='Find best input frequency for desired PLL Output frequency using the normally stocked oscillators at Mouser', action='store_true', required=False)
parser.add_argument('-B', '--bestFile', help='Find best input frequency for desired PLL Output frequency using frequencies read from <filename>', default='none', required=False)
parser.add_argument('-f', '--filename', help=' Save PLL configuration as VHDL to file.', default='pll.vhd', required=False)
parser.add_argument('-n', '--name', help='Specify different VHDL entity name than the default \'pll\'', default='pll', required=False)

args = parser.parse_args()

command=[]
command.append('icepll')
command.append('-i')
command.append(str(args.input))
command.append('-o')
command.append(str(args.output))
if args.primitive:
    command.append('-p')

if args.disableSimple:
    command.append('-S')

if args.best:
    command.append('-b')

if not args.bestFile == 'none':
    command.append('-B')
    command.append(str(args.bestFile))


COMPONENT="SB_PLL40_PAD" if args.primitive else "SB_PLL40_CORE"
ENTITY=args.name

result = subprocess.run(command, check=True, capture_output=True)
result=str(result).split("\\n")


F_PLLIN = result[1].split()[1]
F_PLLOUT_r = result[2].split()[1]
F_PLLOUT_a = result[3].split()[1]

FEEDBACK = result[5].split()[1]
F_PFD = result[6].split()[1]
F_VCO = result[7].split()[1]

DIVR = int(result[9].split()[1])
DIVF = int(result[10].split()[1])
DIVQ = int(result[11].split()[1])

FILTER_RANGE=int(result[13].split()[1])


f = open(args.filename, 'w')

f.write("--\n")
f.write("-- PLL configuration\n")
f.write("--\n")
f.write("-- This VHDL module was generated automatically\n")
f.write("-- using the icepll_vhdl.py script and the\n")
f.write("-- icepll tool from the IceStorm project.\n")
f.write("-- Use at your own risk.\n")
f.write("--\n")
f.write("-- Given input frequency:        "+F_PLLIN+" MHz\n")
f.write("-- Requested output frequency:   "+F_PLLOUT_r+" MHz\n")
f.write("-- Achieved output frequency:    "+F_PLLOUT_a+" MHz\n")
f.write("--\n")
f.write("library IEEE;\n")
f.write("use IEEE.STD_LOGIC_1164.ALL;\n")
f.write("use IEEE.numeric_std.all;\n")
f.write("\n")
f.write("entity "+ENTITY+" is\n")
f.write("  port(\n")
f.write("    clock_in : in std_logic;\n")
f.write("    clock_out : out std_logic;\n")
f.write("    locked : out std_logic\n")
f.write("  );\n")
f.write("end entity "+ENTITY+";\n")
f.write("\n")
f.write("architecture behavioral of "+ENTITY+" is\n")
f.write("\n")
f.write("  component "+COMPONENT+" is\n")
f.write("    generic (\n")
f.write("      FEEDBACK_PATH : String := \""+FEEDBACK+"\";\n")
f.write("      DIVR : unsigned(3 downto 0) := \""+"{0:04b}".format(DIVR)+"\";\n")
f.write("      DIVF : unsigned(6 downto 0) := \""+"{0:07b}".format(DIVF)+"\";\n")
f.write("      DIVQ : unsigned(2 downto 0) := \""+"{0:03b}".format(DIVQ)+"\";\n")
f.write("      FILTER_RANGE : unsigned(2 downto 0) := \""+"{0:03b}".format(FILTER_RANGE)+"\"\n")
f.write("    );\n")
f.write("    port (\n")
f.write("      LOCK : out std_logic;\n")
f.write("      RESETB : in std_logic;\n")
f.write("      BYPASS : in std_logic;\n")
f.write("      REFERENCECLK : in std_logic;\n")
f.write("      PLLOUTGLOBAL : out std_logic\n")
f.write("    );\n")
f.write("  end component;\n")
f.write("\n")
f.write("begin\n")
f.write("\n")
f.write("  inst_pll : "+COMPONENT+"\n")
f.write("    port map(\n")
f.write("      LOCK => locked,\n")
f.write("      RESETB => '1',\n")
f.write("      BYPASS => '0',\n")
f.write("      REFERENCECLK => clock_in,\n")
f.write("      PLLOUTGLOBAL => clock_out\n")
f.write("    );\n")
f.write("\n")
f.write("end architecture behavioral;\n")

f.close()
