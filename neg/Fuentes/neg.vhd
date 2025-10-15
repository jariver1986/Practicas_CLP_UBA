library IEEE;
use IEEE.std_logic_1164.all;

-- Declaracion de entidad
entity neg is
    port(
        a_i : in std_logic;
        b_o : out std_logic
    );
end;

-- Cuerpo de arquitectura
architecture neg_arq of neg is
    -- Parte declarativa
begin
    -- Parte descriptiva
    b_o <= not a_i;
end;
