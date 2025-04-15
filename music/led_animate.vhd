library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_animate is
  generic(
    glyph : std_logic_vector(15 downto 0) :=  "1101110010011001"
  );
  port(
    clkFrame : in std_logic;
    leds1 : out std_logic_vector(7 downto 0);
    leds2 : out std_logic_vector(7 downto 0);
    leds3 : out std_logic_vector(7 downto 0);
    leds4 : out std_logic_vector(7 downto 0)
  );
end entity led_animate;


architecture behavioral of led_animate is

  signal counter : integer range 0 to 7 := 0;

begin

  proc_animate : process(clkFrame)
    begin
      if rising_edge(clkFrame) then
        case counter is
          when 0 =>
            leds1(7 downto 0) <= glyph(15 downto 12) & "1111";
            leds2(7 downto 0) <= glyph(11 downto 8) & "1111";
            leds3(7 downto 0) <= glyph(7 downto 4) & "1111";
            leds4(7 downto 0) <= glyph(3 downto 0) & "1111";

          when 1 =>
            leds1(7 downto 0) <= glyph(14 downto 12) & "1111" & glyph(15);
            leds2(7 downto 0) <= glyph(10 downto 8) & "1111" & glyph(11);
            leds3(7 downto 0) <= glyph(6 downto 4) & "1111" & glyph(7);
            leds4(7 downto 0) <= glyph(2 downto 0) & "1111" & glyph(3);

          when 2 =>
            leds1(7 downto 0) <= glyph(13 downto 12) & "1111" & glyph(15 downto 14);
            leds2(7 downto 0) <= glyph(9 downto 8) & "1111" & glyph(11 downto 10);
            leds3(7 downto 0) <= glyph(5 downto 4) & "1111" & glyph(7 downto 6);
            leds4(7 downto 0) <= glyph(1 downto 0) & "1111" & glyph(3 downto 2);
          when 3 =>
            leds1(7 downto 0) <= glyph(12) & "1111" & glyph(15 downto 13);
            leds2(7 downto 0) <= glyph(8) & "1111" & glyph(11 downto 9);
            leds3(7 downto 0) <= glyph(4) & "1111" & glyph(7 downto 5);
            leds4(7 downto 0) <= glyph(0) & "1111" & glyph(3 downto 1);

          when 4 =>
            leds1(7 downto 0) <= "1111" & glyph(15 downto 12);
            leds2(7 downto 0) <= "1111" & glyph(11 downto 8);
            leds3(7 downto 0) <= "1111" & glyph(7 downto 4);
            leds4(7 downto 0) <= "1111" & glyph(3 downto 0);

          when 5 =>
            leds1(7 downto 0) <= "111" & glyph(15 downto 12) & "1";
            leds2(7 downto 0) <= "111" & glyph(11 downto 8) & "1";
            leds3(7 downto 0) <= "111" & glyph(7 downto 4) & "1";
            leds4(7 downto 0) <= "111" & glyph(3 downto 0) & "1";

          when 6 =>
            leds1(7 downto 0) <= "11" & glyph(15 downto 12) & "11";
            leds2(7 downto 0) <= "11" & glyph(11 downto 8) & "11";
            leds3(7 downto 0) <= "11" & glyph(7 downto 4) & "11";
            leds4(7 downto 0) <= "11" & glyph(3 downto 0) & "11";

          when 7 =>
            leds1(7 downto 0) <= "1" & glyph(15 downto 12) & "111";
            leds2(7 downto 0) <= "1" & glyph(11 downto 8) & "111";
            leds3(7 downto 0) <= "1" & glyph(7 downto 4) & "111";
            leds4(7 downto 0) <= "1" & glyph(3 downto 0) & "111";


        end case;
      end if;
    end process proc_animate;


  proc_count : process(clkFrame)
    begin
      if rising_edge(clkFrame) then
        counter <= counter + 1;
      end if;
    end process proc_count;





end architecture behavioral;
