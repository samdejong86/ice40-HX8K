library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ps2_rx is
  port(
    clk : in std_logic;
    reset : in std_logic;
    ps2d : in std_logic;  -- ps2 data
    ps2c : in std_logic;  -- ps2 clock
    rx_en : in std_logic; -- receive enable input
    rx_done_tick : out std_logic; -- ps2 receive done tick
    rx_data : out std_logic_vector(7 downto 0) --data received
  );
end entity ps2_rx;

architecture behavioral of ps2_rx is

  type t_state is (IDLE, RX);
  signal state_reg : t_state; -- FSMD state register
  signal state_next : t_state;

  signal filter_reg  : std_logic_vector(7 downto 0); -- shift register filter for ps2c
  signal filter_next : std_logic_vector(7 downto 0); -- next state value of ps2c filter register
  signal f_val_reg : std_logic;                      -- reg for ps2c filter value, either 1 or 0
  signal f_val_next : std_logic;                     -- next state for ps2c filter value
  signal n_reg : unsigned(3 downto 0);               -- register to keep track of bit number
  signal n_next : unsigned(3 downto 0);      --
  signal d_reg : std_logic_vector(10 downto 0);      -- register to shift in rx data
  signal d_next : std_logic_vector(10 downto 0);     --
  signal neg_edge : std_logic;                       -- negative edge of ps2c clock filter value

begin

  -- register for ps2c filter register and filter value
  proc_filter : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        filter_reg <= (others => '0');
        f_val_reg  <= '0';
      else
        filter_reg <= filter_next;
        f_val_reg  <= f_val_next;
      end if;
    end if;
  end process proc_filter;

  -- next state value of ps2c filter: right shift in current ps2c value to register
  filter_next <= ps2c & filter_reg(7 downto 1);

  -- filter value next state, 1 if all bits are 1, 0 if all bits are 0, else no change
  f_val_next <= '1' when filter_reg = "11111111" else
                '0' when filter_reg = "00000000" else
                f_val_reg;

  -- negative edge of filter value: if current value is 1, and next state value is 0
  neg_edge <= f_val_reg and not f_val_next;

  --FSMD state, bit number, and data registers
  proc_fsmd : process(clk)
  begin
  if rising_edge(clk) then
    if reset = '1' then
      state_reg <= IDLE;
      n_reg <= (others => '0');
      d_reg <= (others => '0');
    else
      state_reg <= state_next;
      n_reg <= n_next;
      d_reg <= d_next;
    end if;
  end if;

  end process proc_fsmd;

  -- FSMD next state logic
  proc_fms_decode : process(state_reg, neg_edge, rx_en, ps2d, n_reg, d_reg)
  begin
    state_next <= state_reg;
    rx_done_tick <= '0';
    n_next <= n_reg;
    d_next <= d_reg;

    case (state_reg) is

      when IDLE =>
        if neg_edge = '1' and rx_en = '1' then -- start bit received
          n_next <= "1010"; -- set bit count down to 10
          state_next <= rx; -- go to rx state
        end if;


      when RX => -- shift in 8 data, 1 parity, and 1 stop bit
        if neg_edge = '1' then -- if ps2c negative edge...
          d_next <= ps2d & d_reg(10 downto 1); -- sample ps2d, right shift into data register
          n_next <= n_reg - 1; -- decrement bit count
        end if;


        if n_reg = 0 then -- after 10 bits shifted in, go to done state
          rx_done_tick <= '1'; -- assert dat received done tick
          state_next <= IDLE; -- go back to idle
        end if;


    end case;

  end process proc_fms_decode;

  rx_data <= d_reg(8 downto 1); -- output data bits


end architecture behavioral;
