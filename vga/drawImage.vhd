library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library std ;
use std.textio.all;
use work.rom_package.all;


entity drawImage is
  generic (
    MULTIPLICITY_X : integer := 1;
    MULTIPLICITY_Y : integer := 1;
    HEIGHT : integer := 16;
    WIDTH : integer := 12;
    PALETTE : t_slv_v
  );
  port(
    clk : in std_logic;

    sx : in std_logic_vector(9 downto 0);
    sy : in std_logic_vector(9 downto 0);

    rgb : out std_logic_vector(5 downto 0);

    vsync : in std_logic;
    hsync : in std_logic;

    active : out std_logic;

    address : out std_logic_vector(log2ceil(HEIGHT)-1 downto 0);
    --address : out integer range 0 to HEIGHT-1;
    data : in std_logic_vector(WIDTH*2-1 downto 0);

    startX : in unsigned(9 downto 0);
    startY : in unsigned(9 downto 0)
  );
end entity drawImage;


architecture behavioral of drawImage is

  signal endX   : unsigned(9 downto 0);
  signal endY   : unsigned(9 downto 0);

  type state_t is (BEFORE_1LINE, RIGHTLINE, DRAWLINE, LINEDONE, DONE);
  signal state : state_t := BEFORE_1LINE;

begin

  endX   <= conv_unsigned(startX+width*MULTIPLICITY_X+1,10);
  endY   <= conv_unsigned(startY+height*MULTIPLICITY_Y+1+1,10);

  proc_draw : process(clk)
    variable pixel : std_logic_vector(1 downto 0);
    variable counter_x : integer := 0;--  range 0 to 11 := 0;
    variable counter_y : integer := 0;--range 0 to 15 := 0;
    variable square : std_logic := '0';

    begin
      if rising_edge(clk) then
        if vsync = '0' then
          pixel := (others => '0');
          counter_x := 0;
          counter_y := 0;
          state <= BEFORE_1LINE;
        else

          case(state) is

            when BEFORE_1LINE =>
              if unsigned(sy) = startY then
                state <= RIGHTLINE;
              else
                state <= BEFORE_1LINE;
              end if;

            when RIGHTLINE =>
              if unsigned(sx) = startX then
                active <= '0';
                state <= DRAWLINE;
                address <= conv_std_logic_vector(counter_y, log2ceil(HEIGHT));
              else
                state <= RIGHTLINE;
              end if;

            when DRAWLINE =>
              active <= '1';
              pixel := data(2*(counter_x+1)-1 downto 2*counter_x);
              RGB <= palette(conv_integer(unsigned(pixel)));
              counter_x := counter_x + 1;
              if unsigned(sx) = endX - 1 then
                state <= LINEDONE;
              else
                state <= DRAWLINE;
                address <= conv_std_logic_vector(counter_y, log2ceil(HEIGHT));
              end if;


            when LINEDONE =>
              active <= '0';
              if hsync = '0' then
                if counter_y = HEIGHT*MULTIPLICITY_Y-1 then
                  state <= DONE;
                else
                  counter_y := counter_y +1;
                  counter_x := 0;
                  state <= RIGHTLINE;
                end if;
              else
                state <= LINEDONE;
              end if;

            when DONE =>
              active <= '0';
              null;


          end case;
        end if;

      end if;
    end process proc_draw;

end architecture behavioral;
