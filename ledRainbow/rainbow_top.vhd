library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity rainbow_top is
  port(
    clk12MHz : in std_logic;
    keys     : in std_logic_vector(3 downto 0);
    leds     : out std_logic_vector(7 downto 0);
    lcols    : out std_logic_vector(3 downto 0);
    pio      : out std_logic_vector(8 downto 0)
  );
end entity rainbow_top;

architecture behavioral of rainbow_top is

  signal counter : unsigned(31 downto 0) := (others => '0');

  signal counterRed : integer range 0 to 255 := 0;
  signal counterGreen : integer range 0 to 255 := 85;
  signal counterBlue : integer range 0 to 255 := 170;


  signal led_row1 : std_logic_vector(7 downto 0);
  signal led_row2 : std_logic_vector(7 downto 0);
  signal led_row3 : std_logic_vector(7 downto 0);
  signal led_row4 : std_logic_vector(7 downto 0);

  signal colour : std_logic_vector(23 downto 0);

  signal rgb : std_logic_vector(2 downto 0);

begin

  pio(2 downto 0) <= rgb;
  pio(5 downto 3) <= rgb;
  pio(8 downto 6) <= rgb;

  inst_colour : entity work.colour_generator
    port map(
      clk12MHz => clk12MHz,
      colour => colour,--x"edea40",--0000FF",
      red => rgb(0),
      green => rgb(1),
      blue => rgb(2)
    );

  inst_sine : entity work.sineLoop
    port map(
      clk => counter(18),
      colour => colour
    );

    proc_counter : process(clk12MHz)
      begin
        if rising_edge(clk12MHz) then
          counter <= counter + 1;
        end if;
      end process proc_counter;



end behavioral;
