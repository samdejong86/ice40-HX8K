library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library std ;
use std.textio.all;

use work.useful_package.all;

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

  constant sinData : t_slv_v(MEM_DEPTH-1 downto 0)(DATA_WIDTH-1 downto 0) := init_mem("sines.mif", MEM_DEPTH, DATA_WIDTH);

begin

  colour <= sinData(counter) & sinData(counter+120) & sinData(counter+240);


  proc_count : process(clk)
    begin
      if rising_edge(clk) then
        counter <= counter + 1;
      end if;
    end process proc_count;





end architecture behavioral;
