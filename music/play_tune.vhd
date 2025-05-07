library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library std ;
use std.textio.all;
use work.useful_package.all;



entity play_tune is
  generic(
    notesFile : string := "song.mif";
    songMaxlength : integer := 150
  );
  port(
    clkNote : in std_logic;
    key : in std_logic;
    nowPlaying : out std_logic;
    note : out std_logic_vector(14 downto 0)
  );
end entity play_tune;

architecture behavioral of play_tune is

  constant DATA_WIDTH : integer :=20;

  constant songData : t_slv_v(songMaxlength-1 downto 0)(DATA_WIDTH-1 downto 0) := init_mem(notesFile, songMaxlength, DATA_WIDTH);

  constant songLength : unsigned := unsigned(songData(0));

  type t_state is (IDLE, PLAYNOTE, PAUSE);
  signal state : t_state := IDLE;

  signal noteCounter : integer range 0 to conv_integer(songLength);
  signal holdCounter : unsigned(4 downto 0);

  signal duration : unsigned(4 downto 0);

  signal nowPlaying_l : std_logic := '0';

begin

  proc_tune_FSM : process(clkNote)
    begin
      if rising_edge(clkNote) then
        case(state) is

          when IDLE =>
            nowPlaying_l <= '0';
            holdCounter <= (others => '0');
            noteCounter <= 0;
            note <= (others => '0');
            if key = '1' then
              state <= IDLE;
            else
              nowPlaying_l <= '1';
              note <= songData(noteCounter+1)(19 downto 5);
              duration <= unsigned(songData(noteCounter+1)(4 downto 0));
              state <= PLAYNOTE;
            end if;

          when PLAYNOTE =>
            holdCounter <= holdCounter + 1;
            if holdCounter = duration - 1 then
              note <= (others => '0');
              holdCounter <= (others => '0');
              noteCounter <= noteCounter + 1;
              state <= PAUSE;
            else
              state <= PLAYNOTE;
            end if;


          when PAUSE =>
	   if noteCounter = songLength then
              note <= (others => '0');
              nowPlaying_l <= '0';
              state <= IDLE;
            else
              note <= songData(noteCounter+1)(19 downto 5);
              duration <= unsigned(songData(noteCounter+1)(4 downto 0));
              state <= PLAYNOTE;
            end if;

        end case;
      end if;
    end process proc_tune_FSM;

    nowPlaying <= nowPlaying_l;

end architecture behavioral;
