library IEEE;
use IEEE.std_logic_1164.all;

library IEEE;
use IEEE.std_logic_1164.all;

-- Declaracion de entidad
entity sum1b is
    port(
        a_i   : in  std_logic;  -- bit A
        b_i   : in  std_logic;  -- bit B
        ci_i : in  std_logic;  -- acarreo de entrada
        s_o : out std_logic;  -- suma
        co_o: out std_logic   -- acarreo de salida
    );
end;

-- Cuerpo de arquitectura
architecture sum1b_arq of sum1b is
begin
    -- Suma y acarreo (lógica booleana clásica)
    s_o  <= a_i xor b_i xor ci_i;
    co_o <= (a_i and b_i) or (a_i and ci_i) or (b_i and ci_i);
end;
