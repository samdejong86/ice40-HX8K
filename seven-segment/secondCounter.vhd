library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity secondCounter is
  generic(
    n_ticks : integer := 12000000
  );
  port(
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;
    count_out : out std_logic_vector(11 downto 0)
  );
end entity secondCounter;

architecture behavioral of secondCounter is

  signal counter_unsigned : unsigned(11 downto 0) := (others => '0');
  signal counter_ticks : integer range 0 to n_ticks;

begin

  proc_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        counter_unsigned <= (others => '0');
        counter_ticks <= 0;
      else
        if en = '1' then
          if counter_ticks = n_ticks then
            counter_unsigned <= counter_unsigned + 1;
            counter_ticks <= 0;
          else
            counter_ticks <= counter_ticks+1;
          end if;
        end if;
      end if;
    end if;
  end process proc_counter;

  count_out <= std_logic_vector(counter_unsigned);

end architecture behavioral;
