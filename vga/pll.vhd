-- This VHDL entity was built based on the Verilog generated from
-- the icepll tool.
--
-- Given input frequency:        12.000 MHz
-- Requested output frequency:   25.175 MHz
-- Achieved output frequency:    25.125 MHz
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity pll is
  port(
    clock_in : in std_logic;
    clock_out : out std_logic;
    locked : out std_logic
  );
end entity pll;

architecture behavioral of pll is

  component SB_PLL40_CORE is
    generic (
      FEEDBACK_PATH : String := "SIMPLE";
      DIVR : unsigned(3 downto 0) := "0000";
      DIVF : unsigned(6 downto 0) := "1000010";
      DIVQ : unsigned(2 downto 0) := "101";
      FILTER_RANGE : unsigned(2 downto 0) := "001"
    );
    port (
      LOCK : out std_logic;
      RESETB : in std_logic;
      BYPASS : in std_logic;
      REFERENCECLK : in std_logic;
      PLLOUTGLOBAL : out std_logic
    );
  end component;

begin

  inst_pll : SB_PLL40_CORE
    port map(
      LOCK => locked,
      RESETB => '1',
      BYPASS => '0',
      REFERENCECLK => clock_in,
      PLLOUTGLOBAL => clock_out
    );

end architecture behavioral;
