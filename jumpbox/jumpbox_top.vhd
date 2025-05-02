library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.useful_package.all;

entity jumpbox_top is
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
end entity jumpbox_top;

architecture behavioral of jumpbox_top is

  constant screen_width  : integer := 640;
  constant screen_height : integer := 480;


  constant background : std_logic_vector(5 downto 0) :="001011"; --#00aaff
  signal counter : unsigned(31 downto 0) := (others => '0');


  signal debug1 : std_logic;
  signal debug1_colour : std_logic_vector(5 downto 0) := "111111";

  signal debug2 : std_logic;
  signal debug2_colour : std_logic_vector(5 downto 0) := "111111";

  signal debug3 : std_logic;
  signal debug3_colour : std_logic_vector(5 downto 0) := "111111";


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

  signal vsync : std_logic;
  signal hsync : std_logic;



  signal floor : std_logic;
  signal floor_colour : std_logic_vector(5 downto 0) := "010000"; --#550000
  constant floor_level : integer := screen_height-1 - 32;

  signal jumpBox : std_logic;
  signal jumpBox_colour : std_logic_vector(5 downto 0) := "111111"; --#FFFFFF
  signal jumpBox_x : unsigned(9 downto 0);
  signal jumpBox_y : unsigned(9 downto 0);
  constant jumpbox_width : integer := 16;
  constant jumpbox_height : integer := 16;

  constant levelWidth : integer := screen_width/16;
  constant levelHeight : integer := screen_height/16 -2;
  signal platforms : std_logic;


  constant platformData : t_slv_v(levelHeight-1 downto 0)(levelWidth -1 downto 0) := init_mem("level.mif", levelHeight, levelWidth);
  constant platformData_r : t_slv_v(levelWidth-1 downto 0)(levelHeight -1 downto 0) := rotate_2d_vector(platformData);
  constant platform_colour : std_logic_vector(5 downto 0) := "001100"; --#00FF00

  type t_jumpState is (IDLE, JUMPING, FALLING);
  signal jumpState : t_jumpState := IDLE;

  signal rando : std_logic;


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
      vsync => vsync,
      de => de
    );

  blk_sync_dly : block
    signal vs : std_logic_vector(1 downto 0);
    signal hs : std_logic_vector(1 downto 0);

  begin

  proc_dly_sync : process(clk_pix)
  begin
    if rising_edge(clk_pix) then
      vga_vsync <= vs(1);
      vga_hsync <= hs(1);
      vs(1) <= vs(0);
      hs(1) <= hs(0);
      vs(0) <= vsync;
      hs(0) <= hsync;
    end if;
  end process proc_dly_sync;

  end block blk_sync_dly;


  inst_pll : entity work.pll
    port map(
      clock_in => clk12MHz,
      clock_out => clk_pix,
      locked => locked
      );


  blk_level : block


  begin

    --platforms
    proc_platforms : process(clk_pix)
      variable tmp_y : std_logic_vector(9 downto 0);
      variable tmp_x : std_logic_vector(9 downto 0);
      begin
        if rising_edge(clk_pix) then

          if unsigned(sy) < floor_level then
            tmp_y := (sy srl 4);
            tmp_x := (sx srl 4);

            if platformData(to_integer(unsigned(tmp_y)))(to_integer(unsigned(tmp_x))) = '1' then
              platforms <='1';
            else
              platforms <= '0';
            end if;

          end if;


        end if;
      end process proc_platforms;


  end block blk_level;


  inst_move_x : entity work.move_1D
    generic map(
      GRAVITY => false,
      MAX_POS => screen_width-jumpbox_width-1
    )
    port map(
      clk => counter(17),
      rst => rst_pix,
      forward => keys(0),
      backward => keys(1),
      pos => jumpbox_x,
      pos_perp => jumpbox_y,
      platformData => platformData
    );

  inst_move_y : entity work.move_1D
    generic map(
      GRAVITY => true,
      MAX_POS => floor_level-jumpbox_height,
      dim => levelWidth,
      dim_perp => levelHeight,
      STARTPT => floor_level-jumpbox_height,
      CALC_WIDTH=>20
    )
    port map(
      clk => counter(14),
      rst => rst_pix,
      forward => keys(2),
      pos => jumpbox_y,
      pos_perp => jumpbox_x,
      platformData => platformData_r,
      debugcolor => debug2_colour
    );




  debug1 <= '1' when (unsigned(sx) > 0 and unsigned(sx) < 10) and (unsigned(sy) > 100  and unsigned(sy) < 110) else
           '0';
  debug2 <= '1' when (unsigned(sx) > 10 and unsigned(sx) < 20) and (unsigned(sy) > 100  and unsigned(sy) < 110) else
           '0';
  debug3 <= '1' when (unsigned(sx) > 20 and unsigned(sx) < 30) and (unsigned(sy) > 100  and unsigned(sy) < 110) else
           '0';

  blk_jumbox_draw : block

    constant jumpPalette : t_slv_v(0 to 3)(5 downto 0) := ("100001", --aa0055
                                                           "001001", --00aa55
                                                           "000111", --0055ff
                                                           "000000"); --000000


  begin

  inst_jumpDraw : entity work.drawImage
    generic map(
      HEIGHT => 16,
      WIDTH => 16,
      FILENAME => "jumpbox.mif",
      PALETTE => jumpPalette,
      TRANSPARENT => 3
    )
    port map(
      clk => clk_pix,
      sx => sx,
      sy => sy,
      rgb => jumpBox_colour,
      vsync => vsync,
      hsync => hsync,
      active => jumpBox,
      startX => jumpBox_x,
      startY => jumpBox_y
    );

  end block blk_jumbox_draw;


  blk_draw_floor : block
    constant bricksPalette : t_slv_v(0 to 1)(5 downto 0) := ("100000", --aa0000
                                                             "000000");--000000


  begin


    inst_floorDraw : entity work.drawImage
    generic map(
      HEIGHT => 16,
      WIDTH => 16,
      FILENAME => "bricks.mif",
      PALETTE => bricksPalette,
      MULTIPLICITY_X => levelWidth,
      MULTIPLICITY_Y => 2
    )
    port map(
      clk => clk_pix,
      sx => sx,
      sy => sy,
      rgb => floor_colour,
      vsync => vsync,
      hsync => hsync,
      active => floor,
      startX => (others => '0'),
      startY => to_unsigned(floor_level,10)
    );

  end block blk_draw_floor;


  proc_draw : process(clk_pix)
    begin
      if rising_edge(clk_pix) then
        if de = '1' then
          if rando = '1' then
            RGB <= "110101";
          elsif debug2 = '1' then
            RGB <= debug2_colour;
          elsif debug3 = '1' then
            RGB <= debug3_colour;
          elsif jumpBox = '1' then
            RGB <= jumpBox_colour;
          elsif platforms = '1' then
            RGB <= platform_colour;
          elsif floor = '1' then
            RGB <= floor_colour;
          else
            RGB <= background;
          end if;
        else
          RGB <= "000000";
        end if;
      end if;
    end process proc_draw;

    -- LFSR: use to generate pseudo random numbers
    blk_LFSR : block
      signal lfsr_en : std_logic;
      signal lfsr_data : std_logic_vector(19 downto 0);

      type t_state_tmp is (IDLE, B1, WAITFORIT, B2);
      signal state_tmp : t_state_tmp := IDLE;

      signal count_t : integer := 0;

      signal rando_x : unsigned(8 downto 0);
      signal rando_y : unsigned(8 downto 0);

      signal valid : std_logic := '0';

    begin


    inst_lfsr : entity work.LFSR
      generic map(
        g_Num_Bits => 20
      )
      port map(
        i_Clk => clk_pix,
        i_enable => '1',
        i_Seed_DV => '0',
        i_Seed_Data => (others => '0'),
        o_LFSR_Data => lfsr_data,
        o_LFSR_Done => open
     );

    --debug1_colour<= lfsr_data(5 downto 0);

    proc_move_rando : process(counter(20))
      begin
        if rising_edge(counter(20)) then

          case(state_tmp) is
            when IDLE =>
              valid <= '0';
              count_t <= 0;
              if keys(3) = '0' then
                rando_x <= unsigned(lfsr_data(19 downto 11));
                rando_y <= unsigned(lfsr_data(8 downto 0));

                if rando_y > 463 then
                  debug3_colour <= "110011";
                else
                  debug3_colour <= "111111";

                end if;

                --if rando_x < 639 and rando_y <479 then
                  --try <= '0';
                valid <= '1';
                state_tmp <= B1;
                --else
                --  try <= '1';
                -- state_tmp <= IDLE;
                --end if;

              else
                state_tmp <= IDLE;
              end if;

            when B1 =>
              if keys(3) = '1' then
                state_tmp <= WAITFORIT;
              else
                state_tmp <= B1;
              end if;

            when WAITFORIT =>
              if keys(3) = '0' then
                valid <= '0';
                state_tmp <= B2;
              else
                state_tmp <= WAITFORIT;
              end if;

            when B2 =>
              if keys(3) = '1' then
                state_tmp <= IDLE;
              else
                state_tmp <= B2;
              end if;



          end case;


        end if;
      end process proc_move_rando;

      rando <= '1' when unsigned(sx) >= rando_x and unsigned(sx) < rando_x+16 and unsigned(sy) > rando_y  and unsigned(sy) < rando_y+16 and valid = '1' else
               '0';
    end block blk_lfsr;



    proc_counter : process(clk_pix)
      begin
        if rising_edge(clk_pix) then
          counter <= counter + 1;
        end if;
      end process proc_counter;

end behavioral;
