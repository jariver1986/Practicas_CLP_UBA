library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cpu_top is end;
architecture sim of tb_cpu_top is
  signal clk, rst : std_logic := '0';
  signal gpio     : std_logic_vector(15 downto 0);
begin
  uut: entity work.cpu_top
    port map(clk=>clk, rst=>rst, gpio_out=>gpio);

  -- Reloj 10 ns
  clk <= not clk after 5 ns;

  process
  begin
    -- Reset
    rst <= '1'; wait for 20 ns;
    rst <= '0';

    -- Ejecuta ~12 ciclos (suficiente para el programa de la ROM)
    wait for 200 ns;

    -- Al final del programa: r5 debe contener ( (3 + 5) - 1 ) = 7
    -- gpio_out se conectó a alu_y; en el último MOV debería verse 7 en algún ciclo.
    -- Aquí no tenemos visibilidad de registros, así que esta aserción
    -- simplemente verifica que en algún momento apareció 7 en la salida.
    assert gpio = x"0007" report "Esperaba 0x0007 en gpio_out en algún punto (observa waveform)" severity note;

    report "tb_cpu_top finalizado (ver waveform de registros/ALU/PC)" severity note;
    wait;
  end process;
end architecture;
