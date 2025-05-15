library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity seven_segment_top is
  port(
    clk12MHz : in std_logic;
    keys     : in std_logic_vector(3 downto 0);
    leds     : out std_logic_vector(7 downto 0);
    lcols    : out std_logic_vector(3 downto 0);

    uart_tx : out std_logic;
    uart_rx : in std_logic;

    hex_0 : out std_logic_vector(6 downto 0);
    hex_1 : out std_logic_vector(6 downto 0)
  );
end entity seven_segment_top;

architecture behavioral of seven_segment_top is

  constant N : integer := 7;


  signal led_row1 : std_logic_vector(7 downto 0) := "11111111";
  signal led_row2 : std_logic_vector(7 downto 0) := "11111111";
  signal led_row3 : std_logic_vector(7 downto 0) := "11111111";
  signal led_row4 : std_logic_vector(7 downto 0) := "11111111";

  signal BCD : std_logic_vector(11 downto 0);
  signal count : std_logic_vector(11 downto 0);

  signal en : std_logic;

  signal rst_timer : std_logic;

  signal rx_data : std_logic_vector(7 downto 0);
  signal rx_done : std_logic;
  signal tx_data : std_logic_vector(7 downto 0);
  signal tx_sent : std_logic;

begin

    inst_ledscan : entity work.ledscan
    port map(
      clk12MHz => clk12MHz,
      leds1    => led_row1,
      leds2    => led_row2,
      leds3    => led_row3,
      leds4    => led_row4,
      leds     => leds,
      lcol     => lcols
    );

  inst_uart_rx : entity work.uart_rx
  generic map(
    g_CLKS_PER_BIT => 625
  )
  port map(
    i_clk => clk12MHz,
    o_RX_Byte => rx_data,
    o_RX_DV => rx_done,
    i_RX_Serial => uart_rx
  );

  inst_uart_tx : entity work.uart_tx
  generic map(
    g_CLKS_PER_BIT => 625
  )
  port map(
    i_clk => clk12MHz,
    i_TX_Byte => tx_data,
    i_TX_DV => tx_sent,
    o_TX_Serial => uart_tx
  );

  proc_data : process(clk12MHz)
  begin
    if rising_edge(clk12MHz) then
      rst_timer <= '0';
      tx_sent <= '0';
      if rx_done = '1' then
        if rx_data = x"47" or rx_data = x"67" then    -- G or g
          en <= '1';
        elsif rx_data = x"53" or rx_data = x"73" then -- S or s
          en <= '0';
        elsif rx_data = x"43" or rx_data = x"63" then -- C or c
          rst_timer <= '1';
        elsif rx_data = x"52" or rx_data = x"72" then -- R or r
          tx_data <= count(7 downto 0);
          tx_sent <= '1';
        end if;

        -- display the last 4 commands on the led display
        led_row4 <= led_row3;
        led_row3 <= led_row2;
        led_row2 <= led_row1;
        led_row1 <= not rx_data;
      end if;

    end if;
  end process proc_data;





  inst_counter : entity work.secondCounter
    port map(
      clk => clk12MHz,
      rst => rst_timer,
      en => en,
      count_out => count
    );


  inst_bin_to_bcd : entity work.DoubleDabble
  generic map(
    Ni => 12,
    N4 => 3
  )
  port map(
    bin => count,
    bcd => BCD
  );


  inst_hex2sseg_0 : entity work.hex2sseg
    port map(
      hex => BCD(N-4 downto N-7),
      sseg => hex_0
    );

  inst_hex2sseg_1 : entity work.hex2sseg
    port map(
      hex => BCD(N downto N-3),
      sseg => hex_1
    );


end behavioral;
