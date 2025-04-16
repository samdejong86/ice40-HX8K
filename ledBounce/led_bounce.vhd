
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_bounce is
  generic (
    startX : integer range 0 to 7 := 1;
    startY : integer range 0 to 3 := 1
  );
  port(
    clk : in std_logic;
    leds1 : out std_logic_vector(7 downto 0);
    leds2 : out std_logic_vector(7 downto 0);
    leds3 : out std_logic_vector(7 downto 0);
    leds4 : out std_logic_vector(7 downto 0)
  );
end entity led_bounce;

architecture behavioral of led_bounce is

  signal xprev : integer range 0 to 7 := 1;
  signal yprev : integer range 0 to 3 := 1;

  signal dirX : std_logic := '0';
  signal dirY : std_logic := '0';

  signal x : integer range 0 to 7 := startX;
  signal y : integer range 0 to 3 := startY;

  type t_grid is array (3 downto 0) of std_logic_vector(7 downto 0);
  signal grid : t_grid;

begin

  proc_bounce : process(clk)
    begin
      if rising_edge(clk) then
        xprev <= x;
        yprev <= y;

        if xprev = 7 then
          dirX <= '1';
          x <= xprev - 1;
        elsif xprev = 0 then
          dirX <= '0';
          x <= xprev + 1;
        else
          if dirX = '0' then
            x <= xprev + 1;
          else
            x  <= xprev - 1;
          end if;
        end if;

        if yprev = 3 then
          dirY <= '1';
          y <= yprev - 1;
        elsif yprev = 0 then
          dirY <= '0';
          y <= yprev + 1;
        else
          if dirY = '0' then
            y <= yprev + 1;
          else
            y <= yprev - 1;
          end if;
        end if;

        grid(0) <= (others => '1');
        grid(1) <= (others => '1');
        grid(2) <= (others => '1');
        grid(3) <= (others => '1');
        grid(y)(x) <= '0';
        grid(yprev)(xprev) <= '0';

      end if;
    end process proc_bounce;

    leds1 <= grid(0);
    leds2 <= grid(1);
    leds3 <= grid(2);
    leds4 <= grid(3);



end architecture behavioral;
