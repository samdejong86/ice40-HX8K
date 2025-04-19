library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_animate is
  generic(
    glyph : std_logic_vector(31 downto 0) :=  x"9F6FF6F9"
  );
  port(
    clkFrame : in std_logic;
    enable : in std_logic;
    leds1 : out std_logic_vector(7 downto 0);
    leds2 : out std_logic_vector(7 downto 0);
    leds3 : out std_logic_vector(7 downto 0);
    leds4 : out std_logic_vector(7 downto 0)
  );
end entity led_animate;


architecture behavioral of led_animate is

  signal counter : integer range 0 to 7 := 0;

  type t_state is (IDLE, START, RUN, ENDING);
  signal state : t_state := IDLE;

begin

  proc_count : process(clkFrame)
    begin
      if rising_edge(clkFrame) then

        case(state) is

          when IDLE =>
            if enable = '0' then
              leds1(7 downto 0) <= (others => '1');
              leds2(7 downto 0) <= (others => '1');
              leds3(7 downto 0) <= (others => '0');
              leds4(7 downto 0) <= (others => '1');
              counter <= 0;
              state <= IDLE;
            else
              state <= START;
            end if;

          when START =>

            -- would prefer
            -- leds4 <= (7 downto (2+counter) => '1') & glyph(31 downto (30-counter));
            -- but ghdl doesn't like that :(

            if counter = 0 then
              leds4 <= (1 downto 0 => glyph(31 downto 30), others => '1');
              leds3 <= (1 downto 0 => glyph(23 downto 22), others => '0');
              leds2 <= (1 downto 0 => glyph(15 downto 14), others => '1');
              leds1 <= (1 downto 0 => glyph(7 downto 6), others => '1');
            elsif counter = 1 then
              leds4 <= (2 downto 0 => glyph(31 downto 29), others => '1');
              leds3 <= (2 downto 0 => glyph(23 downto 21), others => '0');
              leds2 <= (2 downto 0 => glyph(15 downto 13), others => '1');
              leds1 <= (2 downto 0 => glyph(7 downto 5), others => '1');
            elsif counter = 2 then
              leds4 <= (3 downto 0 => glyph(31 downto 28), others => '1');
              leds3 <= (3 downto 0 => glyph(23 downto 20), others => '0');
              leds2 <= (3 downto 0 => glyph(15 downto 12), others => '1');
              leds1 <= (3 downto 0 => glyph(7 downto 4), others => '1');
            elsif counter = 3 then
              leds4 <= (4 downto 0 => glyph(31 downto 27), others => '1');
              leds3 <= (4 downto 0 => glyph(23 downto 19), others => '0');
              leds2 <= (4 downto 0 => glyph(15 downto 11), others => '1');
              leds1 <= (4 downto 0 => glyph(7 downto 3), others => '1');
            elsif counter = 4 then
              leds4 <= (5 downto 0 => glyph(31 downto 26), others => '1');
              leds3 <= (5 downto 0 => glyph(23 downto 18), others => '0');
              leds2 <= (5 downto 0 => glyph(15 downto 10), others => '1');
              leds1 <= (5 downto 0 => glyph(7 downto 2), others => '1');
            elsif counter = 5 then
              leds4 <= (6 downto 0 => glyph(31 downto 25), others => '1');
              leds3 <= (6 downto 0 => glyph(23 downto 17), others => '0');
              leds2 <= (6 downto 0 => glyph(15 downto 9), others => '1');
              leds1 <= (6 downto 0 => glyph(7 downto 1), others => '1');
            end if;
            counter <= counter + 1;
            if counter = 5 then
              counter <= 0;
              state <= RUN;
            else
              state <= START;
            end if;

          when RUN =>
            leds1 <= glyph(7 downto 0)   rol counter;
            leds2 <= glyph(15 downto 8)  rol counter;
            leds3 <= glyph(23 downto 16) rol counter;
            leds4 <= glyph(31 downto 24) rol counter;

            counter <= counter + 1;
            if counter = 7 then
              counter <= 0;
            end if;

            if enable = '0' and counter = 0 then
              state <= ENDING;
            else
              state <= RUN;
            end if;

          when ENDING =>
            if counter = 1 then
              leds1 <= (7 downto 1 => glyph(6 downto 0), others => '1');
              leds2 <= (7 downto 1 => glyph(14 downto 8), others => '1');
              leds3 <= (7 downto 1 => glyph(22 downto 16), others => '0');
              leds4 <= (7 downto 1 => glyph(30 downto 24), others => '1');
            elsif counter = 2 then
              leds1 <= (7 downto 2 => glyph(5 downto 0), others => '1');
              leds2 <= (7 downto 2 => glyph(13 downto 8), others => '1');
              leds3 <= (7 downto 2 => glyph(21 downto 16), others => '0');
              leds4 <= (7 downto 2 => glyph(29 downto 24), others => '1');
            elsif counter = 3 then
              leds1 <= (7 downto 3 => glyph(4 downto 0), others => '1');
              leds2 <= (7 downto 3 => glyph(12 downto 8), others => '1');
              leds3 <= (7 downto 3 => glyph(20 downto 16), others => '0');
              leds4 <= (7 downto 3 => glyph(28 downto 24), others => '1');
            elsif counter = 4 then
              leds1 <= (7 downto 4 => glyph(3 downto 0), others => '1');
              leds2 <= (7 downto 4 => glyph(11 downto 8), others => '1');
              leds3 <= (7 downto 4 => glyph(19 downto 16), others => '0');
              leds4 <= (7 downto 4 => glyph(27 downto 24), others => '1');
            elsif counter = 5 then
              leds1 <= (7 downto 5 => glyph(2 downto 0), others => '1');
              leds2 <= (7 downto 5 => glyph(10 downto 8), others => '1');
              leds3 <= (7 downto 5 => glyph(18 downto 16), others => '0');
              leds4 <= (7 downto 5 => glyph(26 downto 24), others => '1');
            elsif counter = 6 then
              leds1 <= (7 downto 6 => glyph(1 downto 0), others => '1');
              leds2 <= (7 downto 6 => glyph(9 downto 8), others => '1');
              leds3 <= (7 downto 6 => glyph(17 downto 16), others => '0');
              leds4 <= (7 downto 6 => glyph(25 downto 24), others => '1');
            elsif counter = 7 then
              leds1 <= (7 downto 7 => glyph(0 downto 0), others => '1');
              leds2 <= (7 downto 7 => glyph(8 downto 8), others => '1');
              leds3 <= (7 downto 7 => glyph(16 downto 16), others => '0');
              leds4 <= (7 downto 7 => glyph(24 downto 24), others => '1');
            end if;

            counter <= counter + 1;

            if counter = 7 then
              state <= IDLE;
            else
              state <= ENDING;
            end if;

        end case;



      end if;
    end process proc_count;

end architecture behavioral;
