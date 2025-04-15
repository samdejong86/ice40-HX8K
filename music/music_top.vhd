library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity music_top is
  port(
    clk12MHz	:	in	std_logic;
    key1	:	in	std_logic;
    key2	:	in	std_logic;
    key3	:	in	std_logic;
    key4	:	in	std_logic;
    led1	:	out	std_logic;
    led2	:	out	std_logic;
    led3	:	out	std_logic;
    led4	:	out	std_logic;
    led5	:	out	std_logic;
    led6	:	out	std_logic;
    led7	:	out	std_logic;
    led8	:	out	std_logic;
    lcol1	:	out	std_logic;
    lcol2	:	out	std_logic;
    lcol3	:	out	std_logic;
    lcol4	:	out	std_logic;
    spkp	:	out	std_logic;
    spkm	:	out	std_logic
  );
end entity music_top;

architecture behavioral of music_top is

  signal leds : std_logic_vector(7 downto 0);
  signal lcol : std_logic_vector(3 downto 0);

  signal test_data : std_logic_vector(7 downto 0);

  signal beat : std_logic := '0';

  signal noteTime : std_logic_vector(14 downto 0);
  signal note : std_logic;

  signal counter : unsigned(31 downto 0) := (others => '0');


  signal leds1_l : std_logic_vector(7 downto 0);
  signal leds2_l : std_logic_vector(7 downto 0);
  signal leds3_l : std_logic_vector(7 downto 0);
  signal leds4_l : std_logic_vector(7 downto 0);

begin

  spkp <= note;
  spkm <= not note;

  led8 <= leds(7);
  led7 <= leds(6);
  led6 <= leds(5);
  led5 <= leds(4);
  led4 <= leds(3);
  led3 <= leds(2);
  led2 <= leds(1);
  led1 <= leds(0);

  lcol1 <= lcol(0);
  lcol2 <= lcol(1);
  lcol3 <= lcol(2);
  lcol4 <= lcol(3);


  inst_scan : entity work.ledscan
    port map(
      clk12MHz => clk12MHz,
      leds1 => leds1_l,
      leds2 => leds2_l,
      leds3 => leds3_l,
      leds4 => leds4_l,
      leds => leds,
      lcol => lcol
    );

  inst_animate : entity work.led_animate
    port map(
      clkFrame =>counter(20),
      leds1 => leds1_l,
      leds2 => leds2_l,
      leds3 => leds3_l,
      leds4 => leds4_l
    );


  inst_notes : entity work.note_counter
    port map(
      clk12MHz => clk12MHz,
      noteTime => noteTime,
      note => note
    );


  inst_music : entity work.play_tune
    generic map(
      notesFile => "scotlandTheBrave.mif"
    )
    port map(
      clkNote => counter(19),
      key => key1,
      note => noteTime
    );

    proc_counter : process(clk12MHz)
      begin
        if rising_edge(clk12MHz) then
          counter <= counter + 1;
        end if;
      end process proc_counter;

end behavioral;
