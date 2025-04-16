library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity music_top is
  generic(
    MUSIC_FILE : string := ""
  );
  port(
    clk12MHz : in std_logic;
    keys     : in std_logic_vector(3 downto 0);
    leds     : out std_logic_vector(7 downto 0);
    lcols    : out std_logic_vector(3 downto 0);
    spkp     : out std_logic;
    spkm     : out std_logic
  );
end entity music_top;

architecture behavioral of music_top is

  signal noteTime : std_logic_vector(14 downto 0);
  signal note : std_logic;

  signal counter : unsigned(31 downto 0) := (others => '0');

  signal led_row1 : std_logic_vector(7 downto 0);
  signal led_row2 : std_logic_vector(7 downto 0);
  signal led_row3 : std_logic_vector(7 downto 0);
  signal led_row4 : std_logic_vector(7 downto 0);

begin

  spkp <= note;
  spkm <= not note;

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

  inst_animate : entity work.led_animate
    generic map(
      glyph => "0000011001100000"
    )
    port map(
      clkFrame =>counter(20),
      leds1 => led_row1,
      leds2 => led_row2,
      leds3 => led_row3,
      leds4 => led_row4
    );


  inst_notes : entity work.note_counter
    port map(
      clk12MHz => clk12MHz,
      noteTime => noteTime,
      note     => note
    );


  inst_music : entity work.play_tune
    generic map(
      notesFile => MUSIC_FILE
    )
    port map(
      clkNote => counter(19),
      key     => keys(0),
      note    => noteTime
    );

    proc_counter : process(clk12MHz)
      begin
        if rising_edge(clk12MHz) then
          counter <= counter + 1;
        end if;
      end process proc_counter;

end behavioral;
