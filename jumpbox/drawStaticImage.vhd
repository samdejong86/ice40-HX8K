library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_Std.ALL;
library std ;
use std.textio.all;
use work.useful_package.all;

entity drawStaticImage is
  generic(
    ACTIVEHEIGHT : integer := 16;
    HEIGHT : integer := 16;
    WIDTH : integer := 12;
    FILENAME : string := "";
    TRANSPARENT : integer := 4;
    PALETTE : t_slv_v;
    OFFSET : boolean := true
  );
  port(
    clk : in std_logic;
    sx : in std_logic_vector(9 downto 0);
    sy : in std_logic_vector(9 downto 0);
    rgb : out std_logic_vector(5 downto 0);
    startIndex : in integer := 0;
    mirror : in std_logic := '0';
    active : in std_logic;
    active_o : out std_logic
  );
end entity drawStaticImage;


architecture behavioral of drawStaticImage is

  constant NCOLOURS : integer := PALETTE'length;
  constant DATAWIDTH : integer := WIDTH*log2ceil(NCOLOURS);

  constant imageData : t_slv_v(HEIGHT-1 downto 0)(DATAWIDTH-1 downto 0) :=  init_mem(FILENAME, HEIGHT, DATAWIDTH);

begin



  proc_draw : process(clk)
    variable counter_x : integer range 0 to WIDTH-1 := 0;
    variable counter_y : integer range 0 to HEIGHT-1 := 0;
    variable pixels : std_logic_vector(log2ceil(NCOLOURS)-1 downto 0);
    variable pixel : integer;
    variable inProgress : std_logic;
  begin
    if rising_edge(clk) then
      if sy = x"01E0" then-- reset at end of frame

        -- when mirroring, this should start at WIDTH-1
        if mirror = '1' then
          counter_x := WIDTH-1;
        else
          counter_x := 0;
        end if;
        if OFFSET then
          counter_y := 1 + startIndex;
        else
          counter_y := 0 + startIndex;
        end if;
        inProgress := '0';

      else

        if active = '1' then
          active_o <= '1';

          if OFFSET then
            -- when mirroring, this should count down
            if mirror = '1' then
              counter_x := counter_x-1;
            else
              counter_x := counter_x+1;
            end if;
          end if;

          pixels := imageData(counter_y)(log2ceil(NCOLOURS)*(counter_x+1)-1 downto log2ceil(NCOLOURS)*counter_x);
          pixel := to_integer(unsigned(pixels));

          if pixel = TRANSPARENT then
            active_o <= '0';
          end if;

          rgb <= palette(pixel);
          inProgress := '1';

          if not OFFSET then
            -- when mirroring, this should count down
            if mirror = '1' then
              counter_x := counter_x-1;
            else
              counter_x := counter_x+1;
            end if;
          end if;

        else
          active_o <= '0';
        end if;

        if sx = x"0288" and inProgress = '1' then
        -- when mirroring, this should start at WIDTH-1
        if mirror = '1' then
          counter_x := WIDTH-1;
        else
          counter_x := 0;
        end if;
          if counter_y = ACTIVEHEIGHT then
            counter_y := 1 + startIndex;
            inProgress := '0';
          else
            counter_y := counter_y+1;
          end if;
        end if;
      end if;
    end if;


  end process proc_draw;

end architecture behavioral;
