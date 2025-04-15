library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity note_counter is
  port(
    clk12MHz : in std_logic;
    noteTime : in std_logic_vector(14 downto 0);
    note : out std_logic
  );
end entity note_counter;

architecture behavioral of note_counter is

  signal timer : unsigned(14 downto 0) := (others => '0');
  signal note_l :std_logic;
begin

  proc_note_timer: process(clk12MHz)
    begin
      if rising_edge(clk12MHz) then
        if(unsigned(noteTime) = 0) then
          note_l <= '0';
        else
          if timer = unsigned(noteTime) then
            timer <= (others => '0');
            note_l <= not note_l;
          else
            timer <= timer + 1;
          end if;
        end if;
      end if;
    end process proc_note_timer;

    note <= note_l;


end architecture behavioral;
