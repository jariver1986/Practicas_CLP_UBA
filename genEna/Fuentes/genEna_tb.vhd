library ieee;
use ieee.std_logic_1164.all;

entity genEna_tb is
end entity;

architecture tb of genEna_tb is
  -- Señales de prueba
  signal clk_tb : std_logic := '0';
  signal rst_tb : std_logic := '1';
  signal q_tb   : std_logic;

  constant Tclk : time := 10 ns;  -- periodo de reloj = 10 ns (100 MHz aprox.)
begin
  ----------------------------------------------------------------
  -- Generador de reloj
  ----------------------------------------------------------------
  clk_tb <= not clk_tb after Tclk/2;

  ----------------------------------------------------------------
  -- Secuencia de reset
  ----------------------------------------------------------------
  stim_proc : process
  begin
    -- Reset activo
    rst_tb <= '1';
    wait for 5*Tclk;

    -- Quitar reset
    rst_tb <= '0';

    -- Esperar suficiente tiempo para ver varios pulsos
    wait for 2000 ns;

    -- Terminar simulación
    report "Fin de la simulación" severity note;
    wait;
  end process;

  ----------------------------------------------------------------
  -- Instancia del DUT
  ----------------------------------------------------------------
  dut : entity work.genEna
    generic map(
      N => 10        -- pulso cada 10 ciclos de reloj
    )
    port map(
      clk_i => clk_tb,
      rst_i => rst_tb,
      q_o   => q_tb
    );

end architecture;
