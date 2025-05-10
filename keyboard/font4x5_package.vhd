library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package font4x8 is

  constant single_space : std_logic_vector(7 downto 0) := x"00";

  -- symbols
  constant space       : std_logic_vector(31 downto 0) := x"00000000";
  constant explamation : std_logic_vector(31 downto 0) := x"00005F00"; -- !
  constant question    : std_logic_vector(31 downto 0) := x"02015906"; -- ?
  constant full_stop   : std_logic_vector(31 downto 0) := x"00400000"; -- .
  constant colon       : std_logic_vector(31 downto 0) := x"00002400"; -- :
  constant semi_colon  : std_logic_vector(31 downto 0) := x"00402400"; -- ;
  constant plus        : std_logic_vector(31 downto 0) := x"00081C08"; -- +
  constant minus       : std_logic_vector(31 downto 0) := x"00080808"; -- -
  constant divide      : std_logic_vector(31 downto 0) := x"40300C02"; -- /
  constant multiply    : std_logic_vector(31 downto 0) := x"62142846"; -- x
  constant equals      : std_logic_vector(31 downto 0) := x"14141414"; -- =
  constant fwd_slash   : std_logic_vector(31 downto 0) := x"020C3040"; -- \
  constant open_sq     : std_logic_vector(31 downto 0) := x"00FF8100"; -- [
  constant close_sq    : std_logic_vector(31 downto 0) := x"0081FF00"; -- ]
  constant open_br     : std_logic_vector(31 downto 0) := x"3C428100"; -- (
  constant close_br    : std_logic_vector(31 downto 0) := x"0081423C"; -- )
  constant singlequote : std_logic_vector(31 downto 0) := x"00030000"; -- '
  constant doublequote : std_logic_vector(31 downto 0) := x"00018003"; -- "
  constant dollar      : std_logic_vector(31 downto 0) := x"244BD224"; -- $
  constant pound       : std_logic_vector(31 downto 0) := x"247E247E"; -- #
  constant atsign      : std_logic_vector(31 downto 0) := x"7E425A5E"; -- @
  constant carat       : std_logic_vector(31 downto 0) := x"0C02020C"; -- ^
  constant percent     : std_logic_vector(31 downto 0) := x"C333CCC3"; -- %
  constant amperstand  : std_logic_vector(31 downto 0) := x"76899660"; -- &
  constant asterisk    : std_logic_vector(31 downto 0) := x"2A1C1C2A"; -- *
  constant curl_open   : std_logic_vector(31 downto 0) := x"08768181"; -- {
  constant curl_close  : std_logic_vector(31 downto 0) := x"81817608"; -- }
  constant pipe        : std_logic_vector(31 downto 0) := x"0000FF00"; -- |
  constant comma       : std_logic_vector(31 downto 0) := x"00806000"; -- ,
  constant underscore  : std_logic_vector(31 downto 0) := x"80808080"; -- _
  constant anglequote  : std_logic_vector(31 downto 0) := x"00010204"; -- `
  constant tilde       : std_logic_vector(31 downto 0) := x"04020402"; -- ~
  constant angle_open  : std_logic_vector(31 downto 0) := x"10284482"; -- <
  constant angle_close : std_logic_vector(31 downto 0) := x"82442810"; -- >


  -- numbers
  constant zero  : std_logic_vector(31 downto 0) := x"7E91897E";
  constant one   : std_logic_vector(31 downto 0) := x"0002FF00";
  constant two   : std_logic_vector(31 downto 0) := x"F2898986";
  constant three : std_logic_vector(31 downto 0) := x"42898976";
  constant four  : std_logic_vector(31 downto 0) := x"000C0AFF";
  constant five  : std_logic_vector(31 downto 0) := x"4F898971";
  constant six   : std_logic_vector(31 downto 0) := x"7E898972";
  constant seven : std_logic_vector(31 downto 0) := x"01E11907";
  constant eight : std_logic_vector(31 downto 0) := x"76898976";
  constant nine  : std_logic_vector(31 downto 0) := x"4689897E";

  -- Uppercase letters
  constant A_u : std_logic_vector(31 downto 0) := x"FE0909FE";
  constant B_u : std_logic_vector(31 downto 0) := x"FF898976";
  constant C_u : std_logic_vector(31 downto 0) := x"7E818142";
  constant D_u : std_logic_vector(31 downto 0) := x"FF81817E";
  constant E_u : std_logic_vector(31 downto 0) := x"FF898981";
  constant F_u : std_logic_vector(31 downto 0) := x"FF090901";
  constant G_u : std_logic_vector(31 downto 0) := x"7E819172";
  constant H_u : std_logic_vector(31 downto 0) := x"FF0808FF";
  constant I_u : std_logic_vector(31 downto 0) := x"0081FF81";
  constant J_u : std_logic_vector(31 downto 0) := x"41817F01";
  constant K_u : std_logic_vector(31 downto 0) := x"FF0814E3";
  constant L_u : std_logic_vector(31 downto 0) := x"FF808080";
  constant M_u : std_logic_vector(31 downto 0) := x"FF0202FF";
  constant N_u : std_logic_vector(31 downto 0) := x"FF0810FF";
  constant O_u : std_logic_vector(31 downto 0) := x"7E81817E";
  constant P_u : std_logic_vector(31 downto 0) := x"FF090906";
  constant Q_u : std_logic_vector(31 downto 0) := x"3E41C1BE";
  constant R_u : std_logic_vector(31 downto 0) := x"FF1929CC";
  constant S_u : std_logic_vector(31 downto 0) := x"46899162";
  constant T_u : std_logic_vector(31 downto 0) := x"01FF0101";
  constant U_u : std_logic_vector(31 downto 0) := x"7F80807F";
  constant V_u : std_logic_vector(31 downto 0) := x"3F40807F";
  constant W_u : std_logic_vector(31 downto 0) := x"FF4040FF";
  constant X_u : std_logic_vector(31 downto 0) := x"EF1010EF";
  constant Y_u : std_logic_vector(31 downto 0) := x"0304F807";
  constant Z_u : std_logic_vector(31 downto 0) := x"E1918987";

  -- Lowercase letters
  constant a_l : std_logic_vector(31 downto 0) := x"1824243C";
  constant b_l : std_logic_vector(31 downto 0) := x"FF909060";
  constant c_l : std_logic_vector(31 downto 0) := x"1C222214";
  constant d_l : std_logic_vector(31 downto 0) := x"609090FF";
  constant e_l : std_logic_vector(31 downto 0) := x"3C4A4A24";
  constant f_l : std_logic_vector(31 downto 0) := x"08FE0902";
  constant g_l : std_logic_vector(31 downto 0) := x"18A4A478";
  constant h_l : std_logic_vector(31 downto 0) := x"FF1010E0";
  constant i_l : std_logic_vector(31 downto 0) := x"00003A00";
  constant j_l : std_logic_vector(31 downto 0) := x"60807A00";
  constant k_l : std_logic_vector(31 downto 0) := x"FF205088";
  constant l_l : std_logic_vector(31 downto 0) := x"00007E00";
  constant m_l : std_logic_vector(31 downto 0) := x"3C08083C";
  constant n_l : std_logic_vector(31 downto 0) := x"3C040438";
  constant o_l : std_logic_vector(31 downto 0) := x"18242418";
  constant p_l : std_logic_vector(31 downto 0) := x"FC242418";
  constant q_l : std_logic_vector(31 downto 0) := x"182424FC";
  constant r_l : std_logic_vector(31 downto 0) := x"3C040408";
  constant s_l : std_logic_vector(31 downto 0) := x"242A2A12";
  constant t_l : std_logic_vector(31 downto 0) := x"043E0400";
  constant u_l : std_logic_vector(31 downto 0) := x"1C20203C";
  constant v_l : std_logic_vector(31 downto 0) := x"0C10201C";
  constant w_l : std_logic_vector(31 downto 0) := x"3C10103C";
  constant x_l : std_logic_vector(31 downto 0) := x"62142846";
  constant y_l : std_logic_vector(31 downto 0) := x"18A06018";
  constant z_l : std_logic_vector(31 downto 0) := x"242C3424";



end package;
