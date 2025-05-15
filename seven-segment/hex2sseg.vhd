library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity hex2sseg is
  port(
    hex : in std_logic_vector(3 downto 0);
    sseg : out std_logic_vector(6 downto 0)
  );
end entity hex2sseg;

architecture behavioral of hex2sseg is

  signal hex_u : unsigned(3 downto 0);

begin

  hex_u <= unsigned(hex);

  sseg <= "0111111" when hex_u = "0000" else
          "0000110" when hex_u = "0001" else
          "1011011" when hex_u = "0010" else
          "1001111" when hex_u = "0011" else
          "1100110" when hex_u = "0100" else

          "1101101" when hex_u = "0101" else
          "1111101" when hex_u = "0110" else
          "0000111" when hex_u = "0111" else
          "1111111" when hex_u = "1000" else
          "1101111" when hex_u = "1001" else
          "1011111" when hex_u = "1010" else
          "1111100" when hex_u = "1011" else
          "0111001" when hex_u = "1100" else
          "1011110" when hex_u = "1101" else
          "1111001" when hex_u = "1110" else

          "1110001" when hex_u = "1111" else
          "1111111";



end architecture behavioral;
