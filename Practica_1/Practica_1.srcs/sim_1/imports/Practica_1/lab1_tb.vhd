---------------------------------------------------------
-- Nombre del componente: lab1_tb
--
-- Funcion: Probar el funcionamiento del componente lab1
---------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lab1_tb is
end;

architecture lab1_tb_arq of lab1_tb is

	-- Declaracion del componente a probar
	component lab1 is
		port(
			swt: in std_logic_vector(3 downto 0);
			led: out std_logic_vector(3 downto 0)
		);
	end component;

	-- Declaracion de las senales de prueba
	signal switches: std_logic_vector(3 downto 0);
	signal leds: std_logic_vector(3 downto 0);
	signal e_led: std_logic_vector(3 downto 0);
	
	-- Funcion para generar los valores de salida esperados en funcion de la entrada
	function expected_led(swt: std_logic_vector(3 downto 0)) return std_logic_vector is
		variable aux: std_logic_vector(3 downto 0);
	begin
		aux(0) := not swt(0);
		aux(1) := swt(1) and not swt(2);
		aux(3) := swt(2) and swt(3);
		aux(2) := aux(1) or aux(3);

		return aux;
	end function;
	
begin

	-- Instancia del componente a probar
	DUT: lab1
		port map(
			swt => switches,
			led => leds
		);

	-- Generacion de las senales de prueba y verificacion
	process
		variable i: natural := 0;
	begin
		while (i < 255) loop
			wait for 50 ns;
			switches <= std_logic_vector(to_unsigned(i, 4));
			wait for 10 ns;
			e_led <= expected_led(switches);
			wait for 10 ns;
			if (leds = e_led) then
				report "La salida LED es correcta en " & time'image(now);
			else
				report "La salida LED es incorrecta en " & time'image(now) & ": esperado: " & integer'image(to_integer(unsigned(e_led))) & ", actual: " & integer'image(to_integer(unsigned(leds)));
			end if;
			i := i + 2;
		end loop;
	end process;
	
end;