library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library std ;
use std.textio.all;

package rom_package is

  type t_int_v is array(natural range <>) of integer;
  type t_slv_v is array(natural range <>) of std_logic_vector;

  function log2ceil(arg : positive) return natural;

end package rom_package;


package body rom_package is

  function log2ceil(arg : positive) return natural is
    variable tmp : positive;
    variable log : natural;
  begin
    if arg = 1 then	return 0; end if;
    tmp := 1;
    log := 0;
    while arg > tmp loop
      tmp := tmp * 2;
      log := log + 1;
    end loop;
    return log;
  end function;

end package body rom_package;
