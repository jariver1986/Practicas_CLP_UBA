library IEEE;
use IEEE.std_logic_1164.all;

entity shift_reg_tb is
end;

architecture sim of shift_reg_tb is
    constant N : natural := 4;  -- longitud del registro a probar

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal ent_tb : std_logic := '0';
    signal sal_tb : std_logic;
begin
    -- Generador de reloj (20 ns periodo)
    clk_tb <= not clk_tb after 10 ns;

    -- Instancia del registro de corrimiento
    UUT: entity work.shift_reg
        generic map(N => N)
        port map(
            clk => clk_tb,
            rst => rst_tb,
            ent => ent_tb,
            sal => sal_tb
        );

    -- Estímulos de prueba
    stim_proc: process
    begin
        -- Reset activo
        rst_tb <= '1';
        wait for 25 ns;
        rst_tb <= '0';

        -- Ingreso de bits
        ent_tb <= '1'; wait for 20 ns;
        ent_tb <= '0'; wait for 20 ns;
        ent_tb <= '1'; wait for 20 ns;
        ent_tb <= '1'; wait for 20 ns;
        ent_tb <= '0'; wait for 40 ns;

        -- Final
        wait;
    end process;
end;
