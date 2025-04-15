library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_Std.all;
library std ;
use std.textio.all;

entity spROM is
  generic (initFile : string := "dummy_file_name.mif");
  port (
    ADDRESS : in std_logic_vector(2 downto 0);
    DATAOUT : out std_logic_vector(7 downto 0)
  );
end entity spROM;

architecture arcspROM of spROM is

constant ADDR_WIDTH : integer :=3;
constant DATA_WIDTH : integer :=8;



constant MEM_DEPTH : integer := 2**ADDR_WIDTH;
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

constant mem : mem_type := init_mem("test.mif");


begin

  DATAOUT <= mem(2);

end architecture arcspROM;
