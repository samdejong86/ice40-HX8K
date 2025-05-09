library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keyboard is
  port(
    clk : in std_logic;
    reset : in std_logic;
    ps2c : in std_logic;
    ps2d : in std_logic;
    scan_code : out std_logic_vector(7 downto 0);
    scan_code_ready : out std_logic;
    letter_case_out : out std_logic
  );
end entity keyboard;


architecture behavioral of keyboard is

  constant BREAK  : std_logic_vector(7 downto 0) := x"F0"; --break code
  constant SHIFT1 : std_logic_vector(7 downto 0) := x"12"; --first shift scan
  constant SHIFT2 : std_logic_vector(7 downto 0) := x"59"; --second shift scan
  constant CAPS   : std_logic_vector(7 downto 0) := x"58"; --caps lock
  

  type t_state is (lowercase, ignore_break, shift, ignore_shift_break, capslock, ignore_caps_break);
  signal state_reg : t_state;
  signal state_next : t_state;

  signal scan_out : std_logic_vector(7 downto 0);
  signal got_code_tick : std_logic;
  signal scan_done_tick : std_logic;
  signal letter_case : std_logic;
  signal shift_type_reg : std_logic_vector(7 downto 0);
  signal shift_type_next : std_logic_vector(7 downto 0);
  signal caps_num_reg : unsigned(1 downto 0);
  signal caps_num_next : unsigned(1 downto 0);
 

begin

  inst_ps2_rx : entity work.ps2_rx
    port map(
      clk => clk,
      reset => reset,
      rx_en => '1',
      ps2d => ps2d,
      ps2c => ps2c,
      rx_done_tick => scan_done_tick,
      rx_data => scan_out
    );


  proc_FSM_stat : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state_reg      <= lowercase;
        shift_type_reg <= (others => '0');
        caps_num_reg   <= (others => '0');
      else
        state_reg      <= state_next;
        shift_type_reg <= shift_type_next;
        caps_num_reg   <= caps_num_next;
      end if;
    end if;
  end process proc_FSM_stat;

  proc_FSM_logic : process(scan_done_tick, scan_out, caps_num_reg, shift_type_reg, state_reg)
  begin
    
    got_code_tick   <= '0';
    letter_case     <= '0';
    caps_num_next   <= caps_num_reg;
    shift_type_next <= shift_type_reg;
    state_next      <= state_reg;

    case state_reg is

      when lowercase =>
        if scan_done_tick = '1' then
          if scan_out = SHIFT1 or scan_out = SHIFT2 then
            shift_type_next <= scan_out;             
            state_next <= shift;        
          elsif scan_out = CAPS then
            caps_num_next <= "11";      
            state_next <= capslock; 
          elsif scan_out = BREAK then
            state_next <= ignore_break; 
          else
            got_code_tick <= '1';
          end if;          
        end if;


      when ignore_break =>
        if scan_done_tick = '1' then
          state_next <= lowercase;
        end if;


      when shift =>
        letter_case <= '1';
        if scan_done_tick = '1' then
          if scan_out = BREAK then
            state_next <= ignore_shift_break;
          elsif not scan_out = SHIFT1 and not scan_out = SHIFT2 and not scan_out = CAPS then
            got_code_tick <= '1';
          end if;
        end if;

      when ignore_shift_break =>
        if scan_done_tick = '1' then
          if scan_out = shift_type_reg then
            state_next <= lowercase;
          else
            state_next <= shift;
          end if;
        end if;

      when capslock =>
        letter_case <= '1';
        if caps_num_reg = 0 then
          state_next <= lowercase;
        end if;
        if scan_done_tick = '1' then
          if scan_out = CAPS then
            caps_num_next <= caps_num_reg - 1;
          elsif scan_out = BREAK then
            state_next <= ignore_caps_break;
          elsif not scan_out = SHIFT1 and not scan_out = SHIFT2 then
            got_code_tick <= '1';
          end if;
        end if;

      when ignore_caps_break =>
        if scan_done_tick = '1' then
          if scan_out = CAPS then
            caps_num_next <= caps_num_reg - 1;
          end if;
          state_next <= capslock;
        end if;        

    end case;
  end process proc_FSM_logic;

  letter_case_out <= letter_case;
  scan_code_ready <= got_code_tick;
  scan_code <= scan_out;
  

end architecture behavioral;
  
