--------------------------------------------------------
--
-- VHDL implementation of ledscan.v, originally written
-- by Gerald Coe, Devantech Ltd <gerry@devantech.co.uk>
--
-- ledscan takes the four led columns as inputs and outputs them to the led matrix



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ledscan is
  port(
    clk12MHz : in std_logic;
    leds1 : in std_logic_vector(7 downto 0);
    leds2 : in std_logic_vector(7 downto 0);
    leds3 : in std_logic_vector(7 downto 0);
    leds4 : in std_logic_vector(7 downto 0);
    leds : out std_logic_vector(7 downto 0);
    lcol : out std_logic_vector(3 downto 0)
  );
end entity ledscan;

architecture behavioral of ledscan is

  signal timer : unsigned(11 downto 0) := (others => '0');

  signal switch : std_logic_vector(1 downto 0);
begin

  --switch <= std_logic_vector(timer(11 downto 10));

  process(clk12MHz)
    begin
      if rising_edge(clk12MHz) then
        case timer(11 downto 10) is

          when "00" =>
            leds <= leds1;
            lcol <= "1110";

          when "01" =>
            leds <= leds2;
            lcol <= "1101";

          when "10"=>
            leds <= leds3;
            lcol <= "1011";

          when others =>
            leds <= leds4;
            lcol <= "0111";

        end case;
      end if;
    end process;


  process(clk12MHz)
    begin
      if rising_edge(clk12MHz) then
        timer <= timer + 1;
      end if;
    end process;


end behavioral;
