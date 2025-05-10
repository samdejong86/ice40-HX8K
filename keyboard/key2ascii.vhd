library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.font4x8.all;


entity key2ascii is
    Port (
        letter_case : in  std_logic;
        scan_code   : in  std_logic_vector(7 downto 0);
        ascii_code  : out std_logic_vector(31 downto 0)
    );
end key2ascii;

architecture Behavioral of key2ascii is
begin

    process(letter_case, scan_code)
    begin
        if letter_case = '1' then  -- Uppercase
            case scan_code is
                when x"45" => ascii_code <= close_br;--x"29";  -- )
                when x"16" => ascii_code <= explamation;--x"21";  -- !
                when x"1E" => ascii_code <= atsign;--x"40";  -- @
                when x"26" => ascii_code <= pound;--x"23";  -- #
                when x"25" => ascii_code <= dollar;--x"24";  -- $
                when x"2E" => ascii_code <= percent;--x"25";  -- %
                when x"36" => ascii_code <= carat;--x"5E";  -- ^
                when x"3D" => ascii_code <= amperstand;--x"26";  -- &
                when x"3E" => ascii_code <= asterisk;--x"2A";  -- *
                when x"46" => ascii_code <= open_br;--x"28";  -- (
                when x"1C" => ascii_code <= A_u;--x"41";  -- A
                when x"32" => ascii_code <= B_u;--x"42";  -- B
                when x"21" => ascii_code <= C_u;--x"43";  -- C
                when x"23" => ascii_code <= D_u;--x"44";  -- D
                when x"24" => ascii_code <= E_u;--x"45";  -- E
                when x"2B" => ascii_code <= F_u;--x"46";  -- F
                when x"34" => ascii_code <= G_u;--x"47";  -- G
                when x"33" => ascii_code <= H_u;--x"48";  -- H
                when x"43" => ascii_code <= I_u;--x"49";  -- I
                when x"3B" => ascii_code <= J_u;--x"4A";  -- J
                when x"42" => ascii_code <= K_u;--x"4B";  -- K
                when x"4B" => ascii_code <= L_u;--x"4C";  -- L
                when x"3A" => ascii_code <= M_u;--x"4D";  -- M
                when x"31" => ascii_code <= N_u;--x"4E";  -- N
                when x"44" => ascii_code <= O_u;--x"4F";  -- O
                when x"4D" => ascii_code <= P_u;--x"50";  -- P
                when x"15" => ascii_code <= Q_u;--x"51";  -- Q
                when x"2D" => ascii_code <= R_u;--x"52";  -- R
                when x"1B" => ascii_code <= S_u;--x"53";  -- S
                when x"2C" => ascii_code <= T_u;--x"54";  -- T
                when x"3C" => ascii_code <= U_u;--x"55";  -- U
                when x"2A" => ascii_code <= V_u;--x"56";  -- V
                when x"1D" => ascii_code <= W_u;--x"57";  -- W
                when x"22" => ascii_code <= X_u;--x"58";  -- X
                when x"35" => ascii_code <= Y_u;--x"59";  -- Y
                when x"1A" => ascii_code <= Z_u;--x"5A";  -- Z
                when x"0E" => ascii_code <= tilde;--x"7E";  -- ~
                when x"4E" => ascii_code <= underscore;--x"5F";  -- _
                when x"55" => ascii_code <= plus;--x"2B";  -- +
                when x"54" => ascii_code <= curl_open;--x"7B";  -- {
                when x"5B" => ascii_code <= curl_close;--x"7D";  -- }
                when x"5D" => ascii_code <= pipe;--x"7C";  -- |
                when x"4C" => ascii_code <= colon;--x"3A";  -- :
                when x"52" => ascii_code <= doublequote;--x"22";  -- "
                when x"41" => ascii_code <= angle_open;--x"3C";  -- <
                when x"49" => ascii_code <= angle_close;--x"3E";  -- >
                when x"4A" => ascii_code <= question;--x"3F";  -- ?
                when x"29" => ascii_code <= space;--x"20";  -- Space
                when x"5A" => ascii_code <= space;--x"0D";  -- Enter
                when x"66" => ascii_code <= space;--x"08";  -- Backspace
                when x"0D" => ascii_code <= space;--x"09";  -- Tab
                when others => ascii_code <= asterisk;--x"2A"; -- *
            end case;
        else  -- Lowercase
            case scan_code is
                when x"45" => ascii_code <= zero;--x"30";  -- 0
                when x"16" => ascii_code <= one;--x"31";  -- 1
                when x"1E" => ascii_code <= two;--x"32";  -- 2
                when x"26" => ascii_code <= three;--x"33";  -- 3
                when x"25" => ascii_code <= four;--x"34";  -- 4
                when x"2E" => ascii_code <= five;--x"35";  -- 5
                when x"36" => ascii_code <= six;--x"36";  -- 6
                when x"3D" => ascii_code <= seven;--x"37";  -- 7
                when x"3E" => ascii_code <= eight;--x"38";  -- 8
                when x"46" => ascii_code <= nine;--x"39";  -- 9
                when x"1C" => ascii_code <= a_l;--x"61";  -- a
                when x"32" => ascii_code <= b_l;--x"62";  -- b
                when x"21" => ascii_code <= c_l;--x"63";  -- c
                when x"23" => ascii_code <= d_l;--x"64";  -- d
                when x"24" => ascii_code <= e_l;--x"65";  -- e
                when x"2B" => ascii_code <= f_l;--x"66";  -- f
                when x"34" => ascii_code <= g_l;--x"67";  -- g
                when x"33" => ascii_code <= h_l;--x"68";  -- h
                when x"43" => ascii_code <= i_l;--x"69";  -- i
                when x"3B" => ascii_code <= j_l;--x"6A";  -- j
                when x"42" => ascii_code <= k_l;--x"6B";  -- k
                when x"4B" => ascii_code <= l_l;--x"6C";  -- l
                when x"3A" => ascii_code <= m_l;--x"6D";  -- m
                when x"31" => ascii_code <= n_l;--x"6E";  -- n
                when x"44" => ascii_code <= o_l;--x"6F";  -- o
                when x"4D" => ascii_code <= p_l;--x"70";  -- p
                when x"15" => ascii_code <= q_l;--x"71";  -- q
                when x"2D" => ascii_code <= r_l;--x"72";  -- r
                when x"1B" => ascii_code <= s_l;--x"73";  -- s
                when x"2C" => ascii_code <= t_l;--x"74";  -- t
                when x"3C" => ascii_code <= u_l;--x"75";  -- u
                when x"2A" => ascii_code <= v_l;--x"76";  -- v
                when x"1D" => ascii_code <= w_l;--x"77";  -- w
                when x"22" => ascii_code <= x_l;--x"78";  -- x
                when x"35" => ascii_code <= y_l;--x"79";  -- y
                when x"1A" => ascii_code <= z_l;--x"7A";  -- z
                when x"0E" => ascii_code <= anglequote;--x"60";  -- `
                when x"4E" => ascii_code <= minus;--x"2D";  -- -
                when x"55" => ascii_code <= equals;--x"3D";  -- =
                when x"54" => ascii_code <= open_sq;--x"5B";  -- [
                when x"5B" => ascii_code <= close_sq;--x"5D";  -- ]
                when x"5D" => ascii_code <= fwd_slash;--x"5C";  -- \
                when x"4C" => ascii_code <= semi_colon;--x"3B";  -- ;
                when x"52" => ascii_code <= singlequote;--x"27";  -- '
                when x"41" => ascii_code <= comma;--x"2C";  -- ,
                when x"49" => ascii_code <= full_stop;--x"2E";  -- .
                when x"4A" => ascii_code <= divide;--x"2F";  -- /
                when x"29" => ascii_code <= space;--x"20";  -- Space
                when x"5A" => ascii_code <= space;--x"0D";  -- Enter
                when x"66" => ascii_code <= space;--x"08";  -- Backspace
                when x"0D" => ascii_code <= space;--x"09";  -- Tab
                when others => ascii_code <= asterisk;--x"2A"; -- *
            end case;
        end if;
    end process;

end Behavioral;
