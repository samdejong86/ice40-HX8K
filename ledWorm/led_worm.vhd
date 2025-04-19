
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_worm is
  generic (
    wormLength : integer := 5;
    startX : integer range 0 to 7 := 1;
    startY : integer range 0 to 3 := 1
  );
  port(
    clk   : in std_logic;
    keys  : in std_logic_vector(3 downto 0);
    leds1 : out std_logic_vector(7 downto 0);
    leds2 : out std_logic_vector(7 downto 0);
    leds3 : out std_logic_vector(7 downto 0);
    leds4 : out std_logic_vector(7 downto 0)
  );
end entity led_worm;

architecture behavioral of led_worm is

  type t_int_xv is array(wormLength-2 downto 0) of integer range 0 to 7;
  type t_int_yv is array(wormLength-2 downto 0) of integer range 0 to 7;
  signal xprev : t_int_xv := (others => 1);
  signal yprev : t_int_xv :=(others => 1);

  signal dirX : std_logic := '0';
  signal dirY : std_logic := '0';

  signal x : integer range 0 to 7 := startX;
  signal y : integer range 0 to 3 := startY;

  type t_grid is array (3 downto 0) of std_logic_vector(7 downto 0);
  signal grid : t_grid;

begin

  proc_worm : process(clk)
    begin
      if rising_edge(clk) then


        if keys(3) = '0' or keys(2) = '0' or keys(1) = '0' or keys(0) = '0' then
          for i in wormLength-2 downto 1 loop
            xprev(i) <= xprev(i-1);
            yprev(i) <= yprev(i-1);
          xprev(0) <= x;
          yprev(0) <= y;
          end loop;
        end if;

        if keys = "0101" then --→
          x <= x + 1;
        elsif keys = "1010" then --←
          x <= x - 1;
        elsif keys = "0011" then  --↓
          y<=y-1;
        elsif keys = "1100" then --↑
          y<=y+1;
        elsif keys = "1101" then  --↗
          x <= x + 1;
          y <= y + 1;
        elsif keys = "0111" then --↖
          x <= x + 1;
          y <= y - 1;
        elsif keys = "1011" then --↙
          x <= x - 1;
          y <= y - 1;
        elsif keys = "1110" then --↘
          x <= x - 1;
          y <= y + 1;
        end if;

        grid(0) <= (others => '1');
        grid(1) <= (others => '1');
        grid(2) <= (others => '1');
        grid(3) <= (others => '1');
        grid(y)(x) <= '0';

        for i in wormLength-2 downto 0 loop
          grid(yprev(i))(xprev(i)) <= '0';
        end loop;

      end if;
    end process proc_worm;

    leds1 <= grid(0);
    leds2 <= grid(1);
    leds3 <= grid(2);
    leds4 <= grid(3);



end architecture behavioral;
