library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library std ;
use std.textio.all;


entity sineLoop is
  port(
    clk : in std_logic;
    colour : out std_logic_vector(23 downto 0)
  );
end entity sineLoop;


architecture behavioral of sineLoop is


  signal counter : integer range 0 to 360:= 0;

  constant DATA_WIDTH : integer :=8;
  constant MEM_DEPTH : integer := 360;

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

  constant sinData : mem_type := init_mem("sines.mif");


begin

  colour <= sinData(counter) & sinData(counter+120) & sinData(counter+240);


  proc_count : process(clk)
    begin
      if rising_edge(clk) then
        counter <= counter + 1;
      end if;
    end process proc_count;





end architecture behavioral;
