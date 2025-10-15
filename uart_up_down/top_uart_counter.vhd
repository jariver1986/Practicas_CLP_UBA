library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_uart_counter is
  generic(
    CLK_FREQ : integer := 100_000_000; -- ajusta al reloj de tu FPGA
    BAUD     : integer := 115_200
  );
  port(
    clk     : in  std_logic;
    rst_n   : in  std_logic;             -- activo en 0
    uart_rx : in  std_logic;             -- pin RX desde el adaptador USB-UART
    leds    : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of top_uart_counter is
  -- UART
  signal rx_data       : std_logic_vector(7 downto 0);
  signal rx_valid      : std_logic;

  -- Control
  signal en_auto       : std_logic := '0';
  signal step_pulse    : std_logic := '0';
  signal clr_pulse     : std_logic := '0';

  -- Tick ~10 Hz para modo automático
  constant TICK_HZ     : integer := 10;
  constant TICK_DIV    : integer := integer(real(CLK_FREQ)/real(TICK_HZ) + 0.5);
  signal tick_cnt      : integer range 0 to TICK_DIV-1 := 0;
  signal tick_10hz     : std_logic := '0';

  signal q4            : std_logic_vector(3 downto 0);
begin
  leds <= q4;

  -- Instancia UART RX
  u_rx: entity work.uart_rx
    generic map(
      CLK_FREQ => CLK_FREQ,
      BAUD     => BAUD
    )
    port map(
      clk          => clk,
      rst_n        => rst_n,
      rx_i         => uart_rx,
      data_o       => rx_data,
      data_valid_o => rx_valid
    );

  -- Generador de tick 10 Hz (para conteo automático)
  process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        tick_cnt  <= 0;
        tick_10hz <= '0';
      else
        if tick_cnt = TICK_DIV-1 then
          tick_cnt  <= 0;
          tick_10hz <= '1';
        else
          tick_cnt  <= tick_cnt + 1;
          tick_10hz <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Decodificación de comandos UART
  --  '+' o 'i' -> step
  --  'z' o 'r' -> clear
  --  's'       -> start (enable auto)
  --  'p'       -> pause (disable auto)
  process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        en_auto    <= '0';
        step_pulse <= '0';
        clr_pulse  <= '0';
      else
        step_pulse <= '0';
        clr_pulse  <= '0';

        if rx_valid = '1' then
          case character'val(to_integer(unsigned(rx_data))) is
            when '+' | 'i' =>
              step_pulse <= '1';
            when 'z' | 'r' =>
              clr_pulse  <= '1';
            when 's' =>
              en_auto    <= '1';
            when 'p' =>
              en_auto    <= '0';
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;

  -- Instancia del contador (enable con tick si auto)
  u_cnt: entity work.up_counter
    port map(
      clk    => clk,
      rst_n  => rst_n,
      enable => (tick_10hz and en_auto),
      step   => step_pulse,
      clear  => clr_pulse,
      q      => q4
    );
end architecture;
