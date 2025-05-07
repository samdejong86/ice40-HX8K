library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity bounce_top is
  port(
    clk12MHz : in std_logic;
    keys     : in std_logic_vector(3 downto 0);
    leds     : out std_logic_vector(7 downto 0);
    lcols    : out std_logic_vector(3 downto 0)
  );
end entity bounce_top;

architecture behavioral of bounce_top is

  signal counter : unsigned(31 downto 0) := (others => '0');

  signal led_row1 : std_logic_vector(7 downto 0);
  signal led_row2 : std_logic_vector(7 downto 0);
  signal led_row3 : std_logic_vector(7 downto 0);
  signal led_row4 : std_logic_vector(7 downto 0);

begin


  inst_scan : entity work.ledscan
    port map(
      clk12MHz => clk12MHz,
      leds1    => led_row1,
      leds2    => led_row2,
      leds3    => led_row3,
      leds4    => led_row4,
      leds     => leds,
      lcol     => lcols
    );

  inst_animate : entity work.led_bounce
    port map(
      clk =>counter(20),
      leds1 => led_row1,
      leds2 => led_row2,
      leds3 => led_row3,
      leds4 => led_row4
    );

    proc_counter : process(clk12MHz)
      begin
        if rising_edge(clk12MHz) then
          counter <= counter + 1;
        end if;
      end process proc_counter;

end behavioral;
