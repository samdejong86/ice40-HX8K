--
-- implementation of the Double dabble algorithm
-- Ni number of bits in input binary word
-- N4 number of 4-bit output binary-coded decimals: so 4*N4 bits in BCD
-- example: if Ni=13, then N4=4 since 2**13=8192 requires 4 decimal digits
-- https://en.wikipedia.org/wiki/Double_dabble

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DoubleDabble is
	generic(
		Ni  : natural; -- number of bits in the input binary word
		N4  : natural  -- number of 4-bit output binary-coded decimals: so 4*N4 bits in BCD
		);
	port(
		bin : in std_logic_vector((Ni-1) downto 0);    -- input binary word
		bcd : out std_logic_vector((4*N4-1) downto 0)  -- output BCD
		);
end entity;

architecture Behavioral of DoubleDabble is

begin

	bcd_proc: process(bin)
		variable s: unsigned((Ni+4*N4-1) downto 0); -- scratch space
		variable N: natural; -- total number of bits in scratch space (for convenience)
	begin
		s := (others => '0'); -- scratch space: [bcd,bin]
		N := Ni+4*N4;
		s((Ni-1) downto 0) := unsigned(bin); -- lsb are the Ni input bits
		for i in 0 to (Ni-1) loop    -- loop over Ni shifts
			for j in 0 to (N4-1) loop -- look at each BCD 4-bit words
				if s((N-1-4*j) downto (N-4-4*j)) > 4 then
					s((N-1-4*j) downto (N-4-4*j)) := s((N-1-4*j) downto (N-4-4*j)) + 3; -- add 3 if needed
				end if;
			end loop;
			s((N-1) downto 1) := s((N-2) downto 0); -- shift left by one
			s(0) := '0';
		end loop;
		bcd <= std_logic_vector(s((N-1) downto Ni)); -- full BCD are top 4*N4 bits of scratch space
	end process;

end architecture;
