library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity keyboard_top is
    Port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        ps2d    : in  std_logic;
        ps2c    : in  std_logic;
        tx      : out std_logic
    );
end keyboard_top;

architecture Behavioral of keyboard_top is

    signal rst               : std_logic;
    signal scan_code         : std_logic_vector(7 downto 0);
    signal ascii_code        : std_logic_vector(7 downto 0);
    signal scan_code_ready   : std_logic;
    signal letter_case       : std_logic;

begin

    rst <= not reset;

    -- Direct entity instantiation for keyboard
    kb_unit: entity work.keyboard
        port map (
            clk             => clk,
            reset           => rst,
            ps2d            => ps2d,
            ps2c            => ps2c,
            scan_code       => scan_code,
            scan_code_ready => scan_code_ready,
            letter_case_out => letter_case
        );


    -- Direct entity instantiation for key2ascii
    k2a_unit: entity work.key2ascii
        port map (
            letter_case => letter_case,
            scan_code   => scan_code,
            ascii_code  => ascii_code
        );


end Behavioral;
