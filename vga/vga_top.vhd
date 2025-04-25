library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity vga_top is
  port(
    clk12MHz : in std_logic;
    keys     : in std_logic_vector(3 downto 0);
    leds     : out std_logic_vector(7 downto 0);
    lcols    : out std_logic_vector(3 downto 0);

    vga_r : out std_logic_vector(1 downto 0);
    vga_g : out std_logic_vector(1 downto 0);
    vga_b : out std_logic_vector(1 downto 0);
    vga_hsync : out std_logic;
    vga_vsync : out std_logic


  );
end entity vga_top;

architecture behavioral of vga_top is

  constant background : std_logic_vector(5 downto 0) :="001101";
  signal counter : unsigned(31 downto 0) := (others => '0');

  signal led_row1 : std_logic_vector(7 downto 0);
  signal led_row2 : std_logic_vector(7 downto 0);
  signal led_row3 : std_logic_vector(7 downto 0);
  signal led_row4 : std_logic_vector(7 downto 0);

  signal sx : std_logic_vector(9 downto 0);
  signal sy : std_logic_vector(9 downto 0);
  signal de : std_logic;

  signal clk_pix : std_logic;
  signal rst_pix : std_logic;
  signal locked : std_logic;

  signal square : std_logic;

  signal RGB : std_logic_vector(5 downto 0);

begin

  vga_r(0) <= RGB(5);
  vga_r(1) <= RGB(4);

  vga_g(0) <= RGB(3);
  vga_g(1) <= RGB(2);

  vga_b(0) <= RGB(1);
  vga_b(1) <= RGB(0);

  rst_pix <= not locked;

  inst_480p : entity work.simple_480p
    port map(
      clk_pix => clk_pix,
      rst_pix => rst_pix,
      sx => sx,
      sy => sy,
      hsync => vga_hsync,
      vsync => vga_vsync,
      de => de
    );

  inst_pll : entity work.pll
    port map(
      clock_in => clk12MHz,
      clock_out => clk_pix,
      locked => locked
      );

  square <= '1' when (unsigned(sx) > 220 and unsigned(sx) < 420) and (unsigned(sy) > 140 and unsigned(sy) < 340) else
            '0';


  RGB <= "100100" when square = '1' else
         "000110" when de = '1' else
         "000000";


    proc_counter : process(clk_pix)
      begin
        if rising_edge(clk_pix) then
          counter <= counter + 1;
        end if;
      end process proc_counter;

end behavioral;
