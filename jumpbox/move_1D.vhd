library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_Std.ALL;

--
-- Calculates position of object in 1-d
--
-- 'forward' and 'backward' inputs move the object on + or - direction when low
--
-- platformData is a 2-d array containing locations of barriers (ie, platforms)
--
-- object is assumed to be 16x16 pixels.
-- Each entry in platformData is assumed to cover a 16x16 pixel area
--
-- 'GRAVITY' enables gravitational acceleration on +tive direction
--
-- Under gravity, position is derived from
--
-- x(t) = x(0)+v(0)t+at^2/2
-- v(t) = v(0) + at
--
-- Assuming constant time intervals (t=n * 1 tick) , this can be modified to give position and
-- velocity at timestamp n:
--
-- x(n) = x(n-1)+v(n-1)+a/2
-- v(n) = v(n-1)+a
--
-- Thus, position and velocity can be calculated iteratively.


use work.useful_package.all;

entity move_1D is
  generic(
    -- If true, objects will 'fall' in the + direction unless there is an obstruction
    GRAVITY : boolean := false;
    -- Maximum position on + direction
    MAX_POS : integer := 639;
    -- Size of platformData 1st dimention
    DIM : integer := 28;
    -- Size of platformData 2nd dimention
    DIM_PERP : integer := 40;
    -- Starting position of object
    STARTPT : integer := 500;
    -- Width of calculations for gravity
    CALC_WIDTH : integer := 1
  );
  port(
    clk : in std_logic;
    rst : in std_logic;

    forward : in std_logic := '1';
    backward : in std_logic := '1';

    -- Force fall stop (when gravity is true)
    stopFall : in std_logic := '0';

    -- position of object
    pos : out unsigned(9 downto 0);
    -- position of object in perpendular direction
    pos_perp : in unsigned(9 downto 0);

    -- 2-d array containing platforms
    platformData : in t_slv_v(DIM-1 downto 0)(DIM_PERP -1 downto 0)

  );
end entity move_1D;

architecture behavioral of move_1D is

  type t_jumpState is (IDLE, JUMPING, FALLING);
  signal jumpState : t_jumpState := IDLE;

  signal pos_l : unsigned(9 downto 0) := to_unsigned(STARTPT,10);

  -- Acceleration in + direction: Use wider vectors for more precision in calculations
  constant a      : unsigned(CALC_WIDTH-1 downto 0) := to_unsigned(2,CALC_WIDTH);
  -- Half of acceleration in + direction
  constant a_half : unsigned(CALC_WIDTH-1 downto 0) := to_unsigned(1,CALC_WIDTH);

begin


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

    variable v_prev : unsigned(CALC_WIDTH-1 downto 0);

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
        elsif platformData(y_index+1)(x_index+1) = '1' then
          canForward := '0';
        elsif pos_l > MAX_POS then
          canForward := '0';

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

        -- Without gravity move forwards
          if forward = '0' then
            if canForward = '1' then
              pos_l <= pos_l + 1;
            end if;
          end if;

          -- Without gravity move backward
          if backward = '0' then
            if canBack = '1' then
              pos_l <= pos_l - 1;
            end if;
          end if;

        else
          -- With gravity:
          case(jumpState) is
            when IDLE =>
              -- when jump is deasserted, start a jump
              if forward = '0' then
                -- Initial velocity of jump
                v_prev := to_unsigned(700,CALC_WIDTH);
                jumpState <= JUMPING;

              -- if it's possible to move in + direction, start falling
              elsif canForward = '1' and stopFall = '0'then
                -- start out at rest
                v_prev := (others => '0');
                jumpState <= FALLING;
              else
                jumpState <= IDLE;
              end if;

            when JUMPING =>
              -- if movement in -tive direction is allowed
              if canBack = '1' then

                --velocity is -tive as object is moving in -tive direction

                -- calculate position based on previous position and velocity
                pos_t := pos_t - v_prev + a_half;
                -- calculate velocity based on previous velocity
                v_prev :=  v_prev - a ;

                -- use top 10 bits of positon
                pos_l <= pos_t(CALC_WIDTH-1 downto CALC_WIDTH-10);

                -- if object has stopped, time to fall.
                if v_prev = 0 then
                  jumpState <= FALLING;
                else
                  jumpState <= JUMPING;
                end if;

              else
                -- movement in -tive direction is blocked, move to falling
                v_prev := (others => '0');
                jumpState <= FALLING;
              end if;

            when FALLING =>
              -- external signal to stop falling
              if stopFall = '1' then
                jumpState <= IDLE;

              -- if object isn't blocked, let it fall
              elsif canForward = '1' then

                --velocity is +tive as object is moving in +tive direction

                -- calculate position based on previous position and velocity
                pos_t := pos_t + v_prev + a_half;
                -- calculate velocity based on previous velocity
                v_prev :=  a + v_prev;

                -- use top 10 bits of positon
                pos_l <= pos_t(CALC_WIDTH-1 downto CALC_WIDTH-10);

                jumpState <= FALLING;
              else
                --object is blocked, go back to idle.
                jumpState <= IDLE;
              end if;


          end case;


        end if;
      end if;
    end if;
  end process proc_move_pos;

  pos <= pos_l;


end architecture behavioral;
