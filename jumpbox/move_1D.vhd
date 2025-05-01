library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_Std.ALL;

use work.jumpbox_package.all;

entity move_1D is
  generic(
    GRAVITY : boolean := false;
    MAX_POS : integer := 639;
    MAXJUMP : integer := 100;
    DIM : integer := 28;
    DIM_PERP : integer := 40;
    STARTPT : integer := 500;
    CALC_WIDTH : integer := 1
  );
  port(
    clk : in std_logic;
    rst : in std_logic;

    forward : in std_logic := '1';
    backward : in std_logic := '1';

    pos : out unsigned(9 downto 0);
    pos_perp : in unsigned(9 downto 0);

    debugcolor : out std_logic_vector(5 downto 0);

    platformData : in t_slv_v(DIM-1 downto 0)(DIM_PERP -1 downto 0)

  );
end entity move_1D;

architecture behavioral of move_1D is

  type t_jumpState is (IDLE, JUMPING, FALLING);
  signal jumpState : t_jumpState := IDLE;

  signal pos_l : unsigned(9 downto 0) := to_unsigned(STARTPT,10);

  constant a_half : unsigned(CALC_WIDTH-1 downto 0) := to_unsigned(1,CALC_WIDTH);
  constant a      : unsigned(CALC_WIDTH-1 downto 0) := to_unsigned(2,CALC_WIDTH);
  constant v_init : unsigned(CALC_WIDTH-1 downto 0) := to_unsigned(0,CALC_WIDTH);

begin


  -- Stop movement when colliding with platform
  proc_move_pos : process(clk)
    variable tmp_y : std_logic_vector(9 downto 0);
    variable tmp_y2 : std_logic_vector(9 downto 0);
    variable tmp_x : std_logic_vector(9 downto 0);
    variable y_index : integer;
    variable y_index2 : integer;
    variable x_index : integer;

    variable offset : unsigned(9 downto 0);
    variable offset_y : unsigned(9 downto 0);
    variable canForward : std_logic := '1';
    variable canBack : std_logic := '1';

    variable bottom : unsigned(9 downto 0);
    variable jumpStart : unsigned(9 downto 0);

    variable v_prev : unsigned(CALC_WIDTH-1 downto 0);
    --variable p_prev : unsigned(9 downto 0);
    --variable n : unsigned(7 downto 0) := (others => '0');

    variable pos_t : unsigned(CALC_WIDTH-1 downto 0) := resize(to_unsigned(STARTPT,10),CALC_WIDTH) sll 10;
  begin
    if rising_edge(clk) then
      if rst = '1' then
        pos_l <= to_unsigned(STARTPT,10);
        pos_t := resize(to_unsigned(STARTPT,10),CALC_WIDTH) sll 10;
        jumpState <= IDLE;
      else

      offset_y := pos_perp - to_unsigned(1,10);
      tmp_y := (std_logic_vector(offset_y) srl 4);
      tmp_y2 := (std_logic_vector(pos_perp) srl 4);
      tmp_x := (std_logic_vector(pos_l) srl 4);
      y_index := to_integer(unsigned(tmp_y));
      y_index2 := to_integer(unsigned(tmp_y2));
      x_index := to_integer(unsigned(tmp_x));


      -- platform ahead
      if platformData(y_index2)(x_index+1) = '1' then
        canForward := '0';
        bottom := pos_l;
      elsif platformData(y_index+1)(x_index+1) = '1' then
        canForward := '0';
        bottom := pos_l;
      elsif pos_l > MAX_POS then
        canForward := '0';
        bottom := pos_l;

      else
        canForward := '1';
      end if;


      offset := pos_l - to_unsigned(1,10);
      tmp_x := (std_logic_vector(offset) srl 4);
      x_index := to_integer(unsigned(tmp_x));

      -- platform behind
      if platformData(y_index2)(x_index) = '1' then
        canBack := '0';
      elsif platformData(y_index+1)(x_index) = '1' then
        canBack := '0';
      elsif pos_l = 0 then
        canBack := '0';
      else
        canBack := '1';
      end if;


      if not GRAVITY then
        if forward = '0' then
          if canForward = '1' then
            pos_l <= pos_l + 1;
          end if;
        end if;

        if backward = '0' then
          if canBack = '1' then
            pos_l <= pos_l - 1;
          end if;
        end if;

      else
        case(jumpState) is
        when IDLE =>
          --pos_t := resize(to_unsigned(STARTPT,10),20) sll 10;
          --debugcolor <= "001100";
          if forward = '0' then
            jumpStart := bottom;
            v_prev := to_unsigned(700,CALC_WIDTH);
            jumpState <= JUMPING;
          elsif canForward = '1' then
            v_prev := (others => '0');
            jumpState <= FALLING;
          else
            jumpState <= IDLE;
          end if;

        when JUMPING =>
          if canBack = '1' then


            pos_t := pos_t - v_prev + a_half;
            v_prev :=  v_prev - a ;

            pos_l <= pos_t(CALC_WIDTH-1 downto CALC_WIDTH-10);


            if v_prev = 0 then
              debugcolor <= "110000";
              jumpState <= FALLING;
            else
              debugcolor <= "111100";
              jumpState <= JUMPING;
            end if;


          -- if (to_unsigned(jumpStart,10) - pos_l) < to_unsigned(MAXJUMP,10) then
          --   if canBack then
          --     pos_l <= pos_l - 1;
          --     jumpState <= JUMPING;
          --   else
          --     v_prev := (others => '0');
          --     --p_prev := pos_l;
          --     jumpState <= FALLING;
          --   end if;



          else
            v_prev := (others => '0');
            jumpState <= FALLING;
          end if;

        when FALLING =>
          --debugcolor <= "000011";
          if canForward = '1' then
            pos_t := pos_t + v_prev + a_half;
            v_prev :=  a + v_prev;

            --pos_l <= pos_t(13 downto 4);
            pos_l <= pos_t(CALC_WIDTH-1 downto CALC_WIDTH-10);

             if pos_l > bottom then
               debugcolor <= "000011";
             elsif pos_l = bottom then
               debugcolor <= "110011";
             else
               debugcolor <= "001111";
             end if;
             --  pos_l <= bottom;
            --   pos_l <= pos_t;
            -- else
            --   pos_l <= to_unsigned(MAX_POS-1,10);
             --  jumpState <= IDLE;
            -- end if;

            jumpState <= FALLING;
          else
            jumpState <= IDLE;
          end if;


      end case;


      end if;
    end if;
    end if;
  end process proc_move_pos;

  pos <= pos_l;


end architecture behavioral;
