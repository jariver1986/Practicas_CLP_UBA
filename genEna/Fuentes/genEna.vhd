library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genEna is
  generic(
    N : positive := 10          -- genera un pulso cada N ciclos de clk_i
  );
  port(
    clk_i : in  std_logic;
    rst_i : in  std_logic;       -- reset síncrono activo en '1'
    q_o   : out std_logic        -- pulso de 1 ciclo
  );
end entity;

architecture genEna_arq of genEna is
  signal cnt : integer range 0 to N-1 := 0;
  signal q   : std_logic := '0';
begin
  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_i = '1' then
        cnt <= 0;
        q   <= '0';
      else
        if cnt = N-1 then
          cnt <= 0;
          q   <= '1';            -- pulso de 1 ciclo
        else
          cnt <= cnt + 1;
          q   <= '0';
        end if;
      end if;
    end if;
  end process;

  q_o <= q;
end architecture;
