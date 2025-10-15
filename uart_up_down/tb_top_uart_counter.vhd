library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_uart_counter is
end entity;

architecture sim of tb_top_uart_counter is
  -- Parámetros de la sim
  constant CLK_FREQ_TB : integer := 50_000_000; -- 50 MHz para sim
  constant BAUD_TB     : integer := 1_000_000;  -- 1 Mbps para hacerla corta
  constant TICK_HZ_TB  : integer := 100;        -- conteo auto más ágil en sim

  signal clk     : std_logic := '0';
  signal rst_n   : std_logic := '0';
  signal uart_rx : std_logic := '1'; -- línea en reposo = '1'
  signal leds    : std_logic_vector(3 downto 0);

  -- Señales internas opcionales a monitorear (desde top con 'signal' o via waves)
begin
  -- Reloj 50 MHz
  clk <= not clk after 10 ns; -- periodo 20 ns

  -- Reset
  process
  begin
    rst_n <= '0';
    wait for 200 ns;
    rst_n <= '1';
    wait;
  end process;

  -- DUT: instanciamos top con genéricos ajustados
  dut: entity work.top_uart_counter
    generic map(
      CLK_FREQ => CLK_FREQ_TB,
      BAUD     => BAUD_TB
    )
    port map(
      clk     => clk,
      rst_n   => rst_n,
      uart_rx => uart_rx,
      leds    => leds
    );

  --------------------------------------------------------------------
  -- Tarea/Procedimiento: enviar un byte por UART en uart_rx (8N1)
  --------------------------------------------------------------------
  procedure uart_send_byte(signal rx : out std_logic; constant byte : std_logic_vector(7 downto 0)) is
    constant bit_time : time := 1 sec / BAUD_TB; -- periodo de bit
  begin
    -- start bit (0)
    rx <= '0';
    wait for bit_time;
    -- 8 bits de datos LSB primero
    for i in 0 to 7 loop
      rx <= byte(i);
      wait for bit_time;
    end loop;
    -- stop bit (1)
    rx <= '1';
    wait for bit_time;
    -- un pequeño idle
    wait for bit_time/2;
  end procedure;

  -- Secuencia de estímulos
  stimulus: process
    function c2slv(ch: character) return std_logic_vector is
      variable tmp: std_logic_vector(7 downto 0);
    begin
      tmp := std_logic_vector(to_unsigned(character'pos(ch), 8));
      return tmp;
    end function;
  begin
    -- Espera salir de reset
    wait until rst_n = '1';
    wait for 50 us;

    -- z -> clear
    uart_send_byte(uart_rx, c2slv('z'));
    wait for 200 us;

    -- + -> step (2 veces)
    uart_send_byte(uart_rx, c2slv('+'));
    wait for 100 us;
    uart_send_byte(uart_rx, c2slv('+'));
    wait for 200 us;

    -- s -> start auto
    uart_send_byte(uart_rx, c2slv('s'));

    -- deja correr un rato para que auto cuente
    wait for 50 ms;

    -- p -> pause
    uart_send_byte(uart_rx, c2slv('p'));

    -- espera y termina
    wait for 5 ms;
    assert false report "FIN DE LA SIMULACION" severity failure;
  end process;

end architecture;
