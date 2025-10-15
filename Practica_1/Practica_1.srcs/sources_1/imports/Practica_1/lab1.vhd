---------------------------------------------------------
-- Nombre del componente: lab1
--
-- Funcion: Implementar funciones de salida para los
--          leds de acuerdo a valores de entrada de
--          los switches
---------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity lab1 is
	port(
		swt: in std_logic_vector(3 downto 0);
		led: out std_logic_vector(3 downto 0)
	);
end entity;

architecture lab1_arq of lab1 is
	signal led_aux: std_logic_vector(3 downto 0);
begin
	led_aux(0) <= not swt(0);
	led_aux(1) <= swt(1) and not swt(2);
	led_aux(3) <= swt(2) and swt(3);
	led_aux(2) <= led_aux(1) or led_aux(3);
	
	led <= led_aux;
	
end architecture;