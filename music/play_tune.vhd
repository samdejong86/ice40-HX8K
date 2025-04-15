library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library std ;
use std.textio.all;

entity play_tune is
  generic(
    notesFile : string := "song.mif";
    songMaxlength : integer := 150
  );
  port(
    clkNote : in std_logic;
    key : in std_logic;
    note : out std_logic_vector(14 downto 0)
  );
end entity play_tune;

architecture behavioral of play_tune is

  constant DATA_WIDTH : integer :=20;

  constant MEM_DEPTH : integer := songMaxlength;
  type mem_type is array (0 to MEM_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);

  impure function init_mem(mif_file_name : in string) return mem_type is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : mem_type;
  begin
    for i in mem_type'range loop
      readline(mif_file, mif_line);
      read(mif_line, temp_bv);
      temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
  end function;

  constant songData : mem_type := init_mem(notesFile);
  constant songLength : unsigned := unsigned(songData(0));

  type t_state is (IDLE, PLAYNOTE, PAUSE);
  signal state : t_state := IDLE;

  signal noteCounter : integer range 0 to conv_integer(songLength);
  signal holdCounter : unsigned(4 downto 0);

  signal duration : unsigned(4 downto 0);

begin

  proc_tune_FSM : process(clkNote)
    begin
      if rising_edge(clkNote) then
        case(state) is

          when IDLE =>
            holdCounter <= (others => '0');
            noteCounter <= 0;
            note <= (others => '0');
            if key = '1' then
              state <= IDLE;
            else
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
              state <= IDLE;
            else
              note <= songData(noteCounter+1)(19 downto 5);
              duration <= unsigned(songData(noteCounter+1)(4 downto 0));
              state <= PLAYNOTE;
            end if;

        end case;
      end if;
    end process proc_tune_FSM;


end architecture behavioral;
