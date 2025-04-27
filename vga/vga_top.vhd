library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.rom_package.all;

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


  constant marioPalette : t_slv_v(0 to 3)(5 downto 0) := ("000000",
                                                          "100100",  --#AA5500
                                                          "110000",  --#FF0000
                                                          "111000"); --#FFAA00




  constant background : std_logic_vector(5 downto 0) :="000000";
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

  signal RGB_l : std_logic_vector(5 downto 0);
  signal RGB : std_logic_vector(5 downto 0);
  signal RGB_l2 : std_logic_vector(5 downto 0);


  signal RGB_ground : std_logic_vector(5 downto 0);
  signal active_ground : std_logic;


  signal mactive : std_logic;
  signal mactive2 : std_logic;

  signal vsync : std_logic;
  signal hsync : std_logic;

  signal startX : unsigned(9 downto 0) := conv_unsigned(100, 10);
  signal startY : unsigned(9 downto 0) := conv_unsigned(100, 10);

  signal startX2 : unsigned(9 downto 0) := conv_unsigned(100, 10);
  signal startY2 : unsigned(9 downto 0) := conv_unsigned(200, 10);

  constant DATA_WIDTH : integer := 24;
  constant MEM_DEPTH  : integer := 16;

  signal romData : t_slv_v(1 downto 0)(DATA_WIDTH -1 downto 0);
  signal addr : t_slv_v(1 downto 0)(log2ceil(MEM_DEPTH)-1 downto 0);


  signal marioData : std_logic_vector(DATA_WIDTH -1 downto 0);
  signal mario_rom_Addr : std_logic_vector(log2ceil(MEM_DEPTH)-1 downto 0);--integer range 0 to MEM_DEPTH - 1;

  signal marioData2 : std_logic_vector(DATA_WIDTH -1 downto 0);
  signal mario_rom_Addr2 : std_logic_vector(log2ceil(MEM_DEPTH)-1 downto 0);--integer range 0 to MEM_DEPTH - 1;


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
      hsync => hsync,
      vsync => vsync, --vga_vsync,
      de => de
    );

  vga_vsync <= vsync;
  vga_hsync <= hsync;

  inst_pll : entity work.pll
    port map(
      clock_in => clk12MHz,
      clock_out => clk_pix,
      locked => locked
      );




  blk_ground : block
    constant groundPalette : t_slv_v(0 to 2)(5 downto 0) := ("100100",  --#AA5500
                                                             "000000",  --#000000
                                                             "111010"); --#FFAAAA

    constant GROUNDBLOCKSIZE : integer := 16;

    signal romData_g : t_slv_v(0 downto 0)(GROUNDBLOCKSIZE*2-1 downto 0);
    signal grnd_rom_addr : std_logic_vector(log2ceil(GROUNDBLOCKSIZE)-1 downto 0);
    signal addr_g : t_slv_v(0 downto 0)(log2ceil(GROUNDBLOCKSIZE)-1

    constant Xposn : unsigned(9 downto 0) := conv_unsigned(0, 10);
    constant Yposn : unsigned(9 downto 0) := conv_unsigned(477-32, 10);
  begin


    inst_ground_rom : entity work.rom
      generic map(
        N_PORTS => 1,
        MIF_FILENAME => "ground.mif",
        DEPTH => GROUNDBLOCKSIZE,
        WIDTH => GROUNDBLOCKSIZE*2
      )
      port map(
        address => addr_g,
        data => romData_g
      );

    inst_ground : entity work.drawImage
      generic map(
        MULTIPLICITY_X => 40,
        MULTIPLICITY_Y => 2,
        HEIGHT => GROUNDBLOCKSIZE,
        WIDTH => GROUNDBLOCKSIZE,
        PALETTE => groundPalette
      )
      port map(
        clk => clk_pix,
        sx => sx,
        sy => sy,
        rgb => RGB_ground,
        vsync => vsync,
        hsync => hsync,
        startX => Xposn,
        startY => Yposn,
        address => grnd_rom_addr,
        data => romData_g(0),
        active => active_ground
      );

    addr_g(0) <= grnd_rom_addr;

  end block blk_ground;




  inst_mario_rom : entity work.rom
     generic map(
       N_PORTS => 2,
       MIF_FILENAME => "mario.mif",
       DEPTH => MEM_DEPTH,
       WIDTH => DATA_WIDTH
     )
     port map(
       address => addr,
       data => romData
     );


  addr(0) <= mario_rom_Addr;
  marioData <= romData(0);

  inst_mario : entity work.drawImage
    generic map(
      HEIGHT => MEM_DEPTH,
      WIDTH => 12,
      PALETTE => marioPalette
    )
    port map(
      clk => clk_pix,
      sx => sx,
      sy => sy,
      rgb => RGB_l,
      vsync => vsync,
      hsync => hsync,
      startX => startX,
      startY => startY,
      address => mario_rom_Addr,
      data => marioData,
      active => mactive
    );


  addr(1) <= mario_rom_Addr2;
  marioData2 <= romData(1);


  inst_mario2 : entity work.drawImage
    generic map(
      HEIGHT => MEM_DEPTH,
      WIDTH => 12,
      PALETTE => marioPalette
    )
    port map(
      clk => clk_pix,
      sx => sx,
      sy => sy,
      rgb => RGB_l2,
      vsync => vsync,
      hsync => hsync,
      startX => startX2,
      startY => startY2,
      address => mario_rom_Addr2,
      data => marioData2,
      active => mactive2
    );





  --RGB <= RGB_l when de = '1' else
  --       "000000";





  square <= '1' when (unsigned(sx) > 220 and unsigned(sx) < 420) and (unsigned(sy) > 140 and unsigned(sy) < 340) else
            '0';


  proc_draw : process(clk_pix)
    begin
      if rising_edge(clk_pix) then
        if de = '1' then
          if active_ground = '1' then
            RGB <= RGB_ground;

          elsif mactive = '1' then
            RGB <= RGB_l;
          elsif mactive2 = '1' then
            RGB <= RGB_l2;
          elsif square = '1' then
            RGB <= "100001";
          else
            RGB <= background;
          end if;
        else
          RGB <= "000000";
        end if;
      end if;
    end process proc_draw;





  --RGB <= RGB_l when mactive = '1' else
       --  "100100" when square = '1' else
       --  "000000" when de = '1' else
    --     "000000";

--  proc_moveMario : procesS(counter(20))
  --  begin
--    if rising_edge(counter(20)) then
--      startX <= startX + 1;
--    end if;
--  end process proc_moveMario;

    proc_counter : process(clk_pix)
      begin
        if rising_edge(clk_pix) then
          counter <= counter + 1;
        end if;
      end process proc_counter;

end behavioral;
