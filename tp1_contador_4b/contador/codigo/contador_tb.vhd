library ieee;
use ieee.std_logic_1164.all;

entity counter2_tb is
end entity;

architecture tb of counter2_tb is
  -- Señales de prueba
  signal clk_tb  : std_logic := '0';
  signal rst_tb  : std_logic := '1';
  signal ena_tb  : std_logic := '1';
  signal q_tb    : std_logic_vector(1 downto 0);
  signal tick_tb : std_logic;

  constant Tclk : time := 10 ns;  -- periodo de reloj = 10 ns
begin
  --------------------------------------------------------------------
  -- Generador de reloj
  --------------------------------------------------------------------
  clk_tb <= not clk_tb after Tclk/2;

  --------------------------------------------------------------------
  -- Estímulos
  --------------------------------------------------------------------
  stim_proc : process
  begin
    -- Reset inicial
    rst_tb <= '1';
    wait for 3*Tclk;
    rst_tb <= '0';

    -- Dejar correr con enable en '1'
    wait for 100*Tclk;

    -- Probar deshabilitar
    ena_tb <= '0';
    wait for 20*Tclk;

    -- Volver a habilitar
    ena_tb <= '1';
    wait for 20*Tclk;

    -- Terminar simulación
    report "Fin de simulacion" severity note;
    wait;
  end process;

  --------------------------------------------------------------------
  -- Instancia del DUT
  --------------------------------------------------------------------
  dut : entity work.counter2
    generic map(
      N => 3       -- genera pulso tick cada 3 cuentas
    )
    port map(
      clk  => clk_tb,
      rst  => rst_tb,
      ena  => ena_tb,
      q    => q_tb,
      tick => tick_tb
    );

end architecture;
