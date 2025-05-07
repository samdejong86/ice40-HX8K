library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity colour_generator is
  port (
    clk12MHz : in std_logic;
    colour : in std_logic_vector(23 downto 0);
    red : out std_logic;
    green : out std_logic;
    blue : out std_logic
    );
end entity  colour_generator;

architecture behavioral of colour_generator is

  signal counter : integer range 0 to 255;

  signal redCount : unsigned(7 downto 0);
  signal greenCount : unsigned(7 downto 0);
  signal blueCount : unsigned(7 downto 0);


begin

  redCount   <= unsigned(colour(23 downto 16));
  greenCount <= unsigned(colour(15 downto 8));
  blueCount  <= unsigned(colour(7 downto 0));

  red <= '0' when counter <= redCount else
         '1';


  green <= '0' when counter <= greenCount else
           '1';


  blue <= '0' when counter <= blueCount else
          '1';


  proc_count : process(clk12MHz)
  begin
    if rising_edge(clk12MHz) then
      counter <= counter + 1;
    end if;
  end process proc_count;






end architecture behavioral;
