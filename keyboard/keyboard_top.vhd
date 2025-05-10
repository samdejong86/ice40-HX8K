library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity keyboard_top is
    Port (
        clk12MHz     : in  std_logic;
        --reset   : in  std_logic;
        ps2d    : in  std_logic;
        ps2c    : in  std_logic;
        leds     : out std_logic_vector(7 downto 0);
        lcols    : out std_logic_vector(3 downto 0)
    );
end keyboard_top;

architecture Behavioral of keyboard_top is

    --signal rst               : std_logic;
    signal scan_code         : std_logic_vector(7 downto 0);
    signal ascii_code        : std_logic_vector(31 downto 0);
    signal scan_code_ready   : std_logic;
    signal letter_case       : std_logic;

    signal led_row1 : std_logic_vector(7 downto 0);
    signal led_row2 : std_logic_vector(7 downto 0);
    signal led_row3 : std_logic_vector(7 downto 0);
    signal led_row4 : std_logic_vector(7 downto 0);

    signal rst : std_logic := '0';
begin

    kb_unit: entity work.keyboard
        port map (
            clk             => clk12MHz,
            reset           => rst,
            ps2d            => ps2d,
            ps2c            => ps2c,
            scan_code       => scan_code,
            scan_code_ready => scan_code_ready,
            letter_case_out => letter_case
        );

    k2a_unit: entity work.key2ascii
        port map (
            letter_case => letter_case,
            scan_code   => scan_code,
            ascii_code  => ascii_code
        );


    inst_scan : entity work.ledscan
    port map(
      clk12MHz => clk12MHz,
      leds1    => led_row1,
      leds2    => led_row2,
      leds3    => led_row3,
      leds4    => led_row4,
      leds     => leds,
      lcol     => lcols
    );

    led_row1 <= not ascii_code(31 downto 24);
    led_row2 <= not ascii_code(23 downto 16);
    led_row3 <= not ascii_code(15 downto 8);
    led_row4 <= not ascii_code(7 downto 0);

end Behavioral;
