library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.useful_package.all;
use work.palettes.all;

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
    vga_vsync : out std_logic;

    spkp     : out std_logic;
    spkm     : out std_logic



  );
end entity jumpbox_top;

architecture behavioral of jumpbox_top is


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

  signal jumpBox : std_logic;
  signal jumpBox_colour : std_logic_vector(5 downto 0) := "111111"; --#FFFFFF
  signal jumpBox_x : unsigned(9 downto 0);
  signal jumpBox_y : unsigned(9 downto 0);

  signal platforms : std_logic;


  signal platform_colour : std_logic_vector(5 downto 0) := "001100"; --#00FF00

  type t_jumpState is (IDLE, JUMPING, FALLING);
  signal jumpState : t_jumpState := IDLE;

  signal rando : std_logic;

  signal duke : std_logic;
  signal dukecolour : std_logic_vector(5 downto 0);

  signal stopFall : std_logic := '0';

  signal onHead : std_logic;

begin

  blk_music : block
    signal counter_m : unsigned(31 downto 0) := (others => '0');
    signal noteTime : std_logic_vector(14 downto 0);
    signal note : std_logic;
  begin

  inst_music : entity work.play_tune
    generic map(
      notesFile => "../music/music-files/scotlandTheBrave.mif"
    )
      port map(
        clkNote => counter_m(19),
        key     => onHead,
        note    => noteTime
      );

  inst_notes : entity work.note_counter
    port map(
      clk12MHz => clk12MHz,
      noteTime => noteTime,
      note     => note
    );

  spkp <= note;
  spkm <= not note;

  proc_counter : process(clk12MHz)
  begin
    if rising_edge(clk12MHz) then
      counter_m <= counter_m + 1;
    end if;
  end process proc_counter;


  end block blk_music;

  inst_scan : entity work.ledscan
    port map(
      clk12MHz => clk12MHz,
      leds1    => "11111111",
      leds2    => "11111111",
      leds3    => "11111111",
      leds4    => "1111111"&onHead,
      leds     => leds,
      lcol     => lcols
    );


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


      inst_draw_platforms : entity work.drawImage
        generic map(
          FILENAME=>"block.mif",
          PALETTE=>blockPalette,
          HEIGHT=>platform_size,
          WIDTH=>platform_size
        )
        port map(
          clk => clk_pix,
          sx =>sx,
          sy => sy,
          rgb => platform_colour,
          active => platforms
        );



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
      stopFall => stopFall,
      pos_perp => jumpbox_x,
      platformData => platformData_r
    );




  debug1 <= '1' when (unsigned(sx) > 0 and unsigned(sx) < 10) and (unsigned(sy) > 100  and unsigned(sy) < 110) else
           '0';
  debug2 <= '1' when (unsigned(sx) > 10 and unsigned(sx) < 20) and (unsigned(sy) > 100  and unsigned(sy) < 110) else
           '0';
  debug3 <= '1' when (unsigned(sx) > 20 and unsigned(sx) < 30) and (unsigned(sy) > 100  and unsigned(sy) < 110) else
           '0';

  blk_jumbox_draw : block


    signal jumpBox_l : std_logic;

    signal startindex : integer := 0;

    signal local_counter : integer range 0 to 3 := 0;

    signal mirror : std_logic;

  begin

    inst_draw_cone : entity work.drawImage
      generic map(
        ACTIVEHEIGHT=>jumpbox_height,
        HEIGHT=>4*jumpbox_height,
        WIDTH=>jumpbox_width,
        FILENAME => "cone.mif",
        PALETTE => conePalette,
        TRANSPARENT => 2,
        OFFSET=>false
      )
      port map(
        clk => clk_pix,
        sx =>sx,
        sy => sy,
        mirror => not keys(0),
        startIndex=> startindex,
        rgb => jumpBox_colour,
        active => jumpBox_l,
        active_o => jumpBox
      );



    jumpBox_l <= '1' when (unsigned(sx) > jumpBox_x and unsigned(sx) <= jumpBox_x+jumpbox_width) and (unsigned(sy) > jumpBox_y  and unsigned(sy) <= jumpBox_y+jumpbox_height) else
                 '0';

    startindex <= local_counter * jumpbox_height;

    proc_walk : process(counter(20))
      begin
        if rising_edge(counter(20)) then
          if keys(1) = '1' and keys(0) = '1' then
            local_counter <= 0;
          else
            if local_counter = 3 then
              local_counter <= 1;
            else
              local_counter <= local_counter+1;
            end if;
          end if;

        end if;
      end process proc_walk;


  end block blk_jumbox_draw;


  blk_duke : block
    signal duke_l : std_logic;
  begin

      inst_draw_block : entity work.drawImage
      generic map(
        ACTIVEHEIGHT=>statue_height,
        HEIGHT => statue_height,
        WIDTH => statue_width,
        FILENAME => "statue.mif",
        PALETTE => statuePalette,
        TRANSPARENT => 1,
        OFFSET=>false
      )
      port map(
        clk => clk_pix,
        sx =>sx,
        sy => sy,
        rgb => dukecolour,
        active => duke_l,
        active_o => duke
      );

      duke_l <= '1' when (unsigned(sx) > statue_x and unsigned(sx) <= statue_x+statue_width) and (unsigned(sy) > statue_y and unsigned(sy) <= statue_y+statue_height) else
           '0';

      stopfall <= '1' when (jumpBox_x +jumpbox_width > statue_x+35 and jumpBox_x <= statue_x + 40) and jumpBox_y + jumpbox_height = statue_y + 2 else
                  '1' when (jumpBox_x +jumpbox_width > statue_x+9 and jumpBox_x <= statue_x + 61)  and jumpBox_y + jumpbox_height = statue_y + 69 else
                  '1' when (jumpBox_x +jumpbox_width > statue_x+43 and jumpBox_x <= statue_x + 65) and jumpBox_y + jumpbox_height = statue_y + 24 else
                  '1' when (jumpBox_x +jumpbox_width > statue_x+5 and jumpBox_x <= statue_x + 16) and jumpBox_y + jumpbox_height = statue_y + 11 else
                  '1' when (jumpBox_x +jumpbox_width > statue_x+20 and jumpBox_x <= statue_x + 32) and jumpBox_y + jumpbox_height = statue_y + 18 else
                  '0';

      onHead <= '0' when (jumpBox_x +jumpbox_width > statue_x+35 and jumpBox_x <= statue_x + 40) and jumpBox_y + jumpbox_height = statue_y + 2 else
                '1';

  end block blk_duke;



  inst_draw_floor : entity work.drawImage
    generic map(
      FILENAME=>"bricks.mif",
      PALETTE=>bricksPalette,
      HEIGHT=>16,
      WIDTH=>16,
      OFFSET=>false
    )
    port map(
      clk => clk_pix,
      sx =>sx,
      sy => sy,
      rgb => floor_colour,
      active => floor
    );


  floor <= '1' when (unsigned(sx) > 0 and unsigned(sx) <= screen_width-1) and (unsigned(sy) > floor_level  and unsigned(sy) <= screen_height-1) else
             '0';

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
          elsif duke = '1' then
            RGB <= dukecolour;
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
    -- blk_LFSR : block
    --   signal lfsr_en : std_logic;
    --   signal lfsr_data : std_logic_vector(19 downto 0);

    --   type t_state_tmp is (IDLE, B1, WAITFORIT, B2);
    --   signal state_tmp : t_state_tmp := IDLE;

    --   signal count_t : integer := 0;

    --   signal rando_x : unsigned(8 downto 0);
    --   signal rando_y : unsigned(8 downto 0);

    --   signal valid : std_logic := '0';

    -- begin


    -- inst_lfsr : entity work.LFSR
    --   generic map(
    --     g_Num_Bits => 20
    --   )
    --   port map(
    --     i_Clk => clk_pix,
    --     i_enable => '1',
    --     i_Seed_DV => '0',
    --     i_Seed_Data => (others => '0'),
    --     o_LFSR_Data => lfsr_data,
    --     o_LFSR_Done => open
    --  );

    -- --debug1_colour<= lfsr_data(5 downto 0);

    -- proc_move_rando : process(counter(20))
    --   begin
    --     if rising_edge(counter(20)) then

    --       case(state_tmp) is
    --         when IDLE =>
    --           valid <= '0';
    --           count_t <= 0;
    --           if keys(3) = '0' then
    --             rando_x <= unsigned(lfsr_data(19 downto 11));
    --             rando_y <= unsigned(lfsr_data(8 downto 0));

    --             if rando_y > 463 then
    --               debug3_colour <= "110011";
    --             else
    --               debug3_colour <= "111111";

    --             end if;

    --             --if rando_x < 639 and rando_y <479 then
    --               --try <= '0';
    --             valid <= '1';
    --             state_tmp <= B1;
    --             --else
    --             --  try <= '1';
    --             -- state_tmp <= IDLE;
    --             --end if;

    --           else
    --             state_tmp <= IDLE;
    --           end if;

    --         when B1 =>
    --           if keys(3) = '1' then
    --             state_tmp <= WAITFORIT;
    --           else
    --             state_tmp <= B1;
    --           end if;

    --         when WAITFORIT =>
    --           if keys(3) = '0' then
    --             valid <= '0';
    --             state_tmp <= B2;
    --           else
    --             state_tmp <= WAITFORIT;
    --           end if;

    --         when B2 =>
    --           if keys(3) = '1' then
    --             state_tmp <= IDLE;
    --           else
    --             state_tmp <= B2;
    --           end if;



    --       end case;


    --     end if;
    --   end process proc_move_rando;

    --   rando <= '1' when unsigned(sx) >= rando_x and unsigned(sx) < rando_x+16 and unsigned(sy) > rando_y  and unsigned(sy) < rando_y+16 and valid = '1' else
    --            '0';
    -- end block blk_lfsr;



    proc_counter : process(clk_pix)
      begin
        if rising_edge(clk_pix) then
          counter <= counter + 1;
        end if;
      end process proc_counter;

end behavioral;
