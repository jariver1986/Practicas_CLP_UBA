library IEEE;
use IEEE.std_logic_1164.all;

entity shift_reg is
    generic (N : natural := 4);  -- longitud del registro (por defecto 4)
    port (
        clk : in std_logic;
        rst : in std_logic;
        ent : in std_logic;
        sal : out std_logic
    );
end;

architecture estruc of shift_reg is
    component ffd
        port(
            clk_i : in std_logic;
            rst_i : in std_logic;
            d_i   : in std_logic;
            q_o   : out std_logic
        );
    end component;

    signal d : std_logic_vector(0 to N);
begin
    -- Instanciación de N flip-flops en cascada
    shift_reg_i : for i in 0 to N-1 generate
        ff_inst : ffd port map(
            clk_i => clk,
            rst_i => rst,
            d_i   => d(i),
            q_o   => d(i+1)
        );
    end generate;

    -- Entrada al primer FF y salida del último
    d(0) <= ent;
    sal  <= d(N);
end;
