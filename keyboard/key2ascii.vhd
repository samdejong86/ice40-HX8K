library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity key2ascii is
    Port (
        letter_case : in  std_logic;
        scan_code   : in  std_logic_vector(7 downto 0);
        ascii_code  : out std_logic_vector(7 downto 0)
    );
end key2ascii;

architecture Behavioral of key2ascii is
begin

    process(letter_case, scan_code)
    begin
        if letter_case = '1' then  -- Uppercase
            case scan_code is
                when x"45" => ascii_code <= x"29";  -- )
                when x"16" => ascii_code <= x"21";  -- !
                when x"1E" => ascii_code <= x"40";  -- @
                when x"26" => ascii_code <= x"23";  -- #
                when x"25" => ascii_code <= x"24";  -- $
                when x"2E" => ascii_code <= x"25";  -- %
                when x"36" => ascii_code <= x"5E";  -- ^
                when x"3D" => ascii_code <= x"26";  -- &
                when x"3E" => ascii_code <= x"2A";  -- *
                when x"46" => ascii_code <= x"28";  -- (
                when x"1C" => ascii_code <= x"41";  -- A
                when x"32" => ascii_code <= x"42";  -- B
                when x"21" => ascii_code <= x"43";  -- C
                when x"23" => ascii_code <= x"44";  -- D
                when x"24" => ascii_code <= x"45";  -- E
                when x"2B" => ascii_code <= x"46";  -- F
                when x"34" => ascii_code <= x"47";  -- G
                when x"33" => ascii_code <= x"48";  -- H
                when x"43" => ascii_code <= x"49";  -- I
                when x"3B" => ascii_code <= x"4A";  -- J
                when x"42" => ascii_code <= x"4B";  -- K
                when x"4B" => ascii_code <= x"4C";  -- L
                when x"3A" => ascii_code <= x"4D";  -- M
                when x"31" => ascii_code <= x"4E";  -- N
                when x"44" => ascii_code <= x"4F";  -- O
                when x"4D" => ascii_code <= x"50";  -- P
                when x"15" => ascii_code <= x"51";  -- Q
                when x"2D" => ascii_code <= x"52";  -- R
                when x"1B" => ascii_code <= x"53";  -- S
                when x"2C" => ascii_code <= x"54";  -- T
                when x"3C" => ascii_code <= x"55";  -- U
                when x"2A" => ascii_code <= x"56";  -- V
                when x"1D" => ascii_code <= x"57";  -- W
                when x"22" => ascii_code <= x"58";  -- X
                when x"35" => ascii_code <= x"59";  -- Y
                when x"1A" => ascii_code <= x"5A";  -- Z
                when x"0E" => ascii_code <= x"7E";  -- ~
                when x"4E" => ascii_code <= x"5F";  -- _
                when x"55" => ascii_code <= x"2B";  -- +
                when x"54" => ascii_code <= x"7B";  -- {
                when x"5B" => ascii_code <= x"7D";  -- }
                when x"5D" => ascii_code <= x"7C";  -- |
                when x"4C" => ascii_code <= x"3A";  -- :
                when x"52" => ascii_code <= x"22";  -- "
                when x"41" => ascii_code <= x"3C";  -- <
                when x"49" => ascii_code <= x"3E";  -- >
                when x"4A" => ascii_code <= x"3F";  -- ?
                when x"29" => ascii_code <= x"20";  -- Space
                when x"5A" => ascii_code <= x"0D";  -- Enter
                when x"66" => ascii_code <= x"08";  -- Backspace
                when x"0D" => ascii_code <= x"09";  -- Tab
                when others => ascii_code <= x"2A"; -- *
            end case;
        else  -- Lowercase
            case scan_code is
                when x"45" => ascii_code <= x"30";  -- 0
                when x"16" => ascii_code <= x"31";  -- 1
                when x"1E" => ascii_code <= x"32";  -- 2
                when x"26" => ascii_code <= x"33";  -- 3
                when x"25" => ascii_code <= x"34";  -- 4
                when x"2E" => ascii_code <= x"35";  -- 5
                when x"36" => ascii_code <= x"36";  -- 6
                when x"3D" => ascii_code <= x"37";  -- 7
                when x"3E" => ascii_code <= x"38";  -- 8
                when x"46" => ascii_code <= x"39";  -- 9
                when x"1C" => ascii_code <= x"61";  -- a
                when x"32" => ascii_code <= x"62";  -- b
                when x"21" => ascii_code <= x"63";  -- c
                when x"23" => ascii_code <= x"64";  -- d
                when x"24" => ascii_code <= x"65";  -- e
                when x"2B" => ascii_code <= x"66";  -- f
                when x"34" => ascii_code <= x"67";  -- g
                when x"33" => ascii_code <= x"68";  -- h
                when x"43" => ascii_code <= x"69";  -- i
                when x"3B" => ascii_code <= x"6A";  -- j
                when x"42" => ascii_code <= x"6B";  -- k
                when x"4B" => ascii_code <= x"6C";  -- l
                when x"3A" => ascii_code <= x"6D";  -- m
                when x"31" => ascii_code <= x"6E";  -- n
                when x"44" => ascii_code <= x"6F";  -- o
                when x"4D" => ascii_code <= x"70";  -- p
                when x"15" => ascii_code <= x"71";  -- q
                when x"2D" => ascii_code <= x"72";  -- r
                when x"1B" => ascii_code <= x"73";  -- s
                when x"2C" => ascii_code <= x"74";  -- t
                when x"3C" => ascii_code <= x"75";  -- u
                when x"2A" => ascii_code <= x"76";  -- v
                when x"1D" => ascii_code <= x"77";  -- w
                when x"22" => ascii_code <= x"78";  -- x
                when x"35" => ascii_code <= x"79";  -- y
                when x"1A" => ascii_code <= x"7A";  -- z
                when x"0E" => ascii_code <= x"60";  -- `
                when x"4E" => ascii_code <= x"2D";  -- -
                when x"55" => ascii_code <= x"3D";  -- =
                when x"54" => ascii_code <= x"5B";  -- [
                when x"5B" => ascii_code <= x"5D";  -- ]
                when x"5D" => ascii_code <= x"5C";  -- \
                when x"4C" => ascii_code <= x"3B";  -- ;
                when x"52" => ascii_code <= x"27";  -- '
                when x"41" => ascii_code <= x"2C";  -- ,
                when x"49" => ascii_code <= x"2E";  -- .
                when x"4A" => ascii_code <= x"2F";  -- /
                when x"29" => ascii_code <= x"20";  -- Space
                when x"5A" => ascii_code <= x"0D";  -- Enter
                when x"66" => ascii_code <= x"08";  -- Backspace
                when x"0D" => ascii_code <= x"09";  -- Tab
                when others => ascii_code <= x"2A"; -- *
            end case;
        end if;
    end process;

end Behavioral;
