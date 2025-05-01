
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity simple_480p is
 generic(
   HPIX : integer := 640;
   VPIX : integer := 480;
   HFP  : integer:= 16;
   HBP  : integer:= 48;
   VFP  : integer := 10;
   VBP  : integer := 33;
   HSYNC_W : integer:= 96;
   VSYNC_W : integer := 2
 );
  port(
    clk_pix : in std_logic;
    rst_pix : in std_logic;
    sx : out std_logic_vector(9 downto 0);
    sy : out std_logic_vector(9 downto 0);
    hsync : out std_logic;
    vsync : out std_logic;
    de : out std_logic
  );
end entity simple_480p;


architecture behavioral of simple_480p is

  constant HA_END : integer := HPIX - 1;
  constant VA_END : integer := VPIX - 1;

  constant HS_STA : integer := HA_END  + HFP;
  constant HS_END : integer := HS_STA + HSYNC_W;
  constant LIN  : integer := HS_END + HBP;

  constant VS_STA : integer := VA_END + VFP;
  constant VS_END : integer := VS_STA + VSYNC_W;
  constant SCREEN : integer := VS_END + VBP;

  signal sx_u : unsigned(9 downto 0);
  signal sy_u : unsigned(9 downto 0);

begin


  hsync <= '0' when sx_u >= HS_STA and sx_u < HS_END else
          '1';

  vsync <= '0' when sy_u >= VS_STA and sy_u < VS_END else
          '1';

  de <= '1' when sx_u <= HA_END and sy_u <= VA_END else
       '0';

  proc_calc_posn : process(clk_pix)
    begin
      if rising_edge(clk_pix) then
        if rst_pix = '1' then
          sx_u <= (others => '0');
          sy_u <= (others => '0');
        else
          if sx_u = LIN then
            sx_u <= (others => '0');
            if sy_u = SCREEN then
              sy_u <= (others => '0');
            else
              sy_u <= sy_u + 1;
            end if;
          else
            sx_u <= sx_u + 1;
          end if;
        end if;
      end if;
    end process proc_calc_posn;

  sx <= std_logic_vector(sx_u);
  sy <= std_logic_vector(sy_u);

end architecture behavioral;
