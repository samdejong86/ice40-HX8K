library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library std ;
use std.textio.all;

use work.jumpbox_package.all;

entity rom is
  generic(
    N_PORTS : integer := 1;
    MIF_FILENAME : string := "";
    DEPTH : integer := 1;
    WIDTH : integer := 1
  );
  port(
    --address : in t_int_v(N_PORTS-1 downto 0);
    address : in t_slv_v(N_PORTS-1 downto 0)(log2ceil(DEPTH)-1 downto 0);
    data : out t_slv_v(N_PORTS-1 downto 0)(WIDTH - 1 downto 0);
    allData : out t_slv_v(DEPTH-1 downto 0)(WIDTH - 1 downto 0)
  );
end entity rom;

architecture behavioral of rom is

  type mem_type is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);

  impure function init_mem(mif_file_name : in string) return mem_type is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(WIDTH-1 downto 0);
    variable temp_mem : mem_type;
  begin
    for i in mem_type'range loop
      readline(mif_file, mif_line);
      read(mif_line, temp_bv);
      temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
  end function;

  constant data_l : mem_type := init_mem(MIF_FILENAME);

begin

  gen_alldata : for i in DEPTH-1 downto 0 generate
    allData(i) <= data_l(i);
  end generate;

  gen_data : for i in N_PORTS - 1 downto 0 generate
    data(i) <= reverse_any_vector(data_l(to_integer(unsigned(address(i)))));
  end generate;





end architecture behavioral;
