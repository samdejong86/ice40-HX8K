library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.useful_package.all;

package palettes is

  constant screen_width  : integer := 640;
  constant screen_height : integer := 480;


  constant levelWidth : integer := screen_width/16;
  constant levelHeight : integer := screen_height/16 -2;


  constant jumpcone_width : integer := 16;
  constant jumpcone_height : integer := 16;

  constant platform_size : integer := 16;


  constant floor_level : integer := screen_height-1 - 32;

  constant platformData : t_slv_v(levelHeight-1 downto 0)(levelWidth -1 downto 0) := init_mem("level.mif", levelHeight, levelWidth);
  constant platformData_r : t_slv_v(levelWidth-1 downto 0)(levelHeight -1 downto 0) := rotate_2d_vector(platformData);


  constant background : std_logic_vector(5 downto 0) :="001011"; --#00aaff

  constant blockPalette : t_slv_v(0 to 2)(5 downto 0) := ("111010", --ffaaaa
                                                          "100100", --aa5500
                                                          "000000");--000000

  constant conePalette : t_slv_v(0 to 3)(5 downto 0) := ("111111", --ffffff
                                                         "111000", --ffaa00
                                                         "101010", --aaaaaa
                                                         "000000");--000000

  constant statuePalette : t_slv_v(0 to 3)(5 downto 0) := ("010101", --555555
                                                          "110000", --ff0000
                                                          "101010", --aaaaaa
                                                          "000000");--000000


  constant bricksPalette : t_slv_v(0 to 1)(5 downto 0) := ("100000", --aa0000
                                                           "000000");--000000



  constant statue_height : integer := 97;
  constant statue_width : integer := 68;

  constant statue_x : unsigned(9 downto 0) := to_unsigned(27*platform_size,10);
  constant statue_y : unsigned(9 downto 0) := to_unsigned(15*platform_size-statue_height,10);
  -- also add positions of fixed objects?


end package palettes;
