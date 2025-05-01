library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library std ;
use std.textio.all;

package jumpbox_package is

  type t_int_v is array(natural range <>) of integer;
  type t_slv_v is array(natural range <>) of std_logic_vector;

  function log2ceil(arg : positive) return natural;
  function ite(cond : boolean; value1 : integer; value2 : integer) return integer;
  function reverse_any_vector (a: in std_logic_vector) return std_logic_vector;
  function rotate_2d_vector(a: in t_slv_v) return t_slv_v;

end package jumpbox_package;



package body jumpbox_package is

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

  function ite(cond : boolean; value1 : integer; value2 : integer) return integer is
  begin
    if cond then
      return value1;
    else
      return value2;
    end if;
  end function;


  function reverse_any_vector (a: in std_logic_vector) return std_logic_vector is
    variable result: std_logic_vector(a'RANGE);
    alias aa: std_logic_vector(a'REVERSE_RANGE) is a;
  begin
    for i in aa'RANGE loop
      result(i) := aa(i);
    end loop;
    return result;
  end;


  function rotate_2d_vector(a: in t_slv_v) return t_slv_v is
    variable result :t_slv_v(a'element'range)(a'range);
  begin
    for i in a'element'range loop
      for j in a'range  loop
        result(i)(j) := a(j)(i);
      end loop;
    end loop;
    return result;
  end;


end package body jumpbox_package;
