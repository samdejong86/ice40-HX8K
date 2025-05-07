library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.useful_package.all;

entity music_top is
  generic(
    MUSIC_FILE_1 : string := "";
    MUSIC_FILE_2 : string := "";
    MUSIC_FILE_3 : string := "";
    MUSIC_FILE_4 : string := ""
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

  constant nSongs : integer := 4;

  signal noteTime : std_logic_vector(14 downto 0);
  signal noteTimes : t_slv_v(nSongs-1 downto 0)(14 downto 0);

  signal note : std_logic;

  signal counter : unsigned(31 downto 0) := (others => '0');

  signal led_row1 : std_logic_vector(7 downto 0) := (others => '1');
  signal led_row2 : std_logic_vector(7 downto 0);
  signal led_row3 : std_logic_vector(7 downto 0);
  signal led_row4 : std_logic_vector(7 downto 0);

  signal playing : std_logic_vector(nSongs-1 downto 0);
  signal anyPlaying : std_logic;

  function getSong(i: integer range 0 to 3) return string is
    begin
      if i=0 then
        return MUSIC_FILE_1;
      elsif i=1 then
        return MUSIC_FILE_2;
      elsif i=2 then
        return MUSIC_FILE_3;
      elsif i=3 then
        return MUSIC_FILE_4;
      end if;
    end function;

begin

  anyPlaying <= playing(0) or playing(1) or playing(2) or playing(3);

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
    port map(
      clkFrame => counter(19),
      enable => anyPlaying,
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


  gen_music : for i in nSongs-1 downto 0 generate
    constant songFile : string := getSong(i);
    signal start : std_logic;
  begin

    inst_music : entity work.play_tune
      generic map(
        notesFile => songFile
      )
      port map(
        clkNote => counter(19),
        key     => start,
        nowPlaying => playing(i),
        note    => noteTimes(i)
      );

    start <= keys(i) or anyPlaying;

  end generate gen_music;

  noteTime <= notetimes(0) when playing(0) = '1' else
              notetimes(1) when playing(1) = '1' else
              notetimes(2) when playing(2) = '1' else
              notetimes(3) when playing(3) = '1' else
              (others => '0');

  proc_counter : process(clk12MHz)
  begin
    if rising_edge(clk12MHz) then
      counter <= counter + 1;
    end if;
  end process proc_counter;

end behavioral;
