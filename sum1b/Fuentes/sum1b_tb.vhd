library IEEE;
use IEEE.std_logic_1164.all;

-- Declaracion de entidad
entity sum1b_tb is
end;

-- Cuerpo de arquitectura
architecture sum1b_tb_arq of sum1b_tb is
    -- Parte declarativa

	signal a_tb : std_logic := '0';
	signal b_tb : std_logic := '0';
	signal ci_tb: std_logic := '0';
	signal co_tb: std_logic;
	signal s_tb : std_logic;
	
begin
    -- Parte descriptiva
	a_tb  <= not a_tb after 20 ns;
	b_tb  <= not b_tb after 40 ns;
	ci_tb <= not ci_tb after 80 ns;
	
	
	sum1b_inst: entity work.sum1b
		port map(
			a_i  => a_tb,
			b_i  => b_tb,
			ci_i => ci_tb,
			s_o  => s_tb,
			co_o => co_tb
			
		);

end;


--
