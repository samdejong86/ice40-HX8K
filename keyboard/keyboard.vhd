--
-- VHDL version of 'keyboard.v', a verilog module written by github user jconenna.
-- Logical flow was designed by that user, I rewrote the code into VHDL.
--
-- Verilog source is available in this repository:
--   https://github.com/jconenna/FPGA-Projects/tree/master
--
-- A useful blog post on the subject written by jconenna can be found here:
--   https://embeddedthoughts.com/2016/07/05/fpga-keyboard-interface/
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keyboard is
  port(
    clk : in std_logic;
    reset : in std_logic;
    ps2c : in std_logic; -- ps2 clock line
    ps2d : in std_logic; -- ps2 data line
    scan_code : out std_logic_vector(7 downto 0); -- scan_code received from keyboard to process
    scan_code_ready : out std_logic; -- signal to outer control system to sample scan_code
    letter_case_out : out std_logic -- output to determine if scan code is converted to lower or upper ascii code for a key
  );
end entity keyboard;


architecture behavioral of keyboard is

  constant BREAK  : std_logic_vector(7 downto 0) := x"F0"; --break code
  constant SHIFT1 : std_logic_vector(7 downto 0) := x"12"; --first shift scan
  constant SHIFT2 : std_logic_vector(7 downto 0) := x"59"; --second shift scan
  constant CAPS   : std_logic_vector(7 downto 0) := x"58"; --caps lock


  type t_state is (lowercase,          -- idle, process lower case letters
                   ignore_break,       -- ignore repeated scan code after break code -F0- reeived
                   shift,              -- process uppercase letters for shift key held
                   ignore_shift_break, -- check scan code after F0, either idle or go back to uppercase
                   capslock,           -- process uppercase letter after capslock button pressed
                   ignore_caps_break); -- check scan code after F0, either ignore repeat, or decrement caps_num

  signal state_reg : t_state;  -- FSM state
  signal state_next : t_state; -- FSM next state

  signal scan_out : std_logic_vector(7 downto 0);        -- scan code received from keyboard
  signal got_code_tick : std_logic;                      -- asserted to write current scan code received to FIFO
  signal scan_done_tick : std_logic;                     -- asserted to signal that ps2_rx has received a scan code
  signal letter_case : std_logic;                        -- 0 for lower case, 1 for uppercase, outputed to use when converting scan code to ascii
  signal shift_type_reg : std_logic_vector(7 downto 0);  -- register to hold scan code for either of the shift keys or caps lock
  signal shift_type_next : std_logic_vector(7 downto 0); -- register to hold scan code for either of the shift keys or caps lock
  signal caps_num_reg : unsigned(1 downto 0);            -- keeps track of number of capslock scan codes received in capslock state (3 before going back to lowecase state)
  signal caps_num_next : unsigned(1 downto 0);           -- keeps track of number of capslock scan codes received in capslock state (3 before going back to lowecase state)


begin

  --  instantiate ps2 receiver
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

  --  FSM stat, shift_type, caps_num register
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

  -- FSM next state logic
  proc_FSM_logic : process(scan_done_tick, scan_out, caps_num_reg, shift_type_reg, state_reg)
  begin

    got_code_tick   <= '0';
    letter_case     <= '0';
    caps_num_next   <= caps_num_reg;
    shift_type_next <= shift_type_reg;
    state_next      <= state_reg;

    case state_reg is

      --  state to process lowercase key strokes, go to uppercase state to process shift/capslock
      when lowercase =>
        --  if scan code received
        if scan_done_tick = '1' then
          --  if code is shift
          if scan_out = SHIFT1 or scan_out = SHIFT2 then
            -- record which shift key was pressed
            shift_type_next <= scan_out;
            -- go to shift state
            state_next <= shift;

          -- if code is capslock
          elsif scan_out = CAPS then
            -- set caps_num to 3, num of capslock scan codes to receive before going back to lowecase
            caps_num_next <= "11";
            -- go to capslock state
            state_next <= capslock;

          -- else if code is break code
          elsif scan_out = BREAK then
            -- go to ignore_break state
            state_next <= ignore_break;

          -- else if code is none of the above...
          else
            -- assert got_code_tick to write scan_out to FIFO
            got_code_tick <= '1';
          end if;
        end if;

      -- state to ignore repeated scan code after break code FO received in lowercase state
      when ignore_break =>
        -- if scan code received,
        if scan_done_tick = '1' then
          -- go back to lowercase state
          state_next <= lowercase;
        end if;

      -- state to process scan codes after shift received in lowercase state
      when shift =>
        -- routed out to convert scan code to upper value for a key
        letter_case <= '1';
        -- if scan code received,
        if scan_done_tick = '1' then
          -- if code is break code
          if scan_out = BREAK then
            -- go to ignore_shift_break state to ignore repeated scan code after F0
            state_next <= ignore_shift_break;
          -- else if code is not shift/capslock
          elsif not scan_out = SHIFT1 and not scan_out = SHIFT2 and not scan_out = CAPS then
            -- assert got_code_tick to write scan_out to FIFO
            got_code_tick <= '1';
          end if;
        end if;

      -- state to ignore repeated scan code after break code F0 received in shift state
      when ignore_shift_break =>
        -- if scan code received
        if scan_done_tick = '1' then
          -- if scan code is shift key initially pressed
          if scan_out = shift_type_reg then
            -- shift/capslock key unpressed, go back to lowercase state
            state_next <= lowercase;

          -- else repeated scan code received, go back to uppercase state
          else
            state_next <= shift;
          end if;
        end if;

      -- state to process scan codes after capslock code received in lowecase state
      when capslock =>
        -- routed out to convert scan code to upper value for a key
        letter_case <= '1';
        -- if capslock code received 3 times,
        if caps_num_reg = 0 then
          -- go back to lowecase state
          state_next <= lowercase;
        end if;

        -- if scan code received
        if scan_done_tick = '1' then

          -- if code is capslock,
          if scan_out = CAPS then
            -- decrement caps_num
            caps_num_next <= caps_num_reg - 1;

          -- else if code is break, go to ignore_caps_break state
          elsif scan_out = BREAK then
            state_next <= ignore_caps_break;

          --else if code isn't a shift key
          elsif not scan_out = SHIFT1 and not scan_out = SHIFT2 then
            -- assert got_code_tick to write scan_out to FIFO
            got_code_tick <= '1';
          end if;
        end if;

      -- state to ignore repeated scan code after break code F0 received in capslock state
      when ignore_caps_break =>
        -- if scan code received
        if scan_done_tick = '1' then
          -- if code is capslock
          if scan_out = CAPS then
            -- decrement caps_num
            caps_num_next <= caps_num_reg - 1;
          end if;
          -- return to capslock state
          state_next <= capslock;
        end if;

    end case;
  end process proc_FSM_logic;

  -- output, route letter_case to output to use during scan to ascii code conversion
  letter_case_out <= letter_case;
  -- output, route got_code_tick to out control circuit to signal when to sample scan_out
  scan_code_ready <= got_code_tick;
  -- route scan code data out
  scan_code <= scan_out;


end architecture behavioral;
