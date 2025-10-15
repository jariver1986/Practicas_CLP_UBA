library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
  port(
    clk : in  std_logic;
    rst : in  std_logic;
    pc  : out unsigned(15 downto 0)
  );
end entity;

architecture rtl of pc is
  signal r : unsigned(15 downto 0) := (others => '0');
begin
  process(clk, rst)
  begin
    if rst = '1' then
      r <= (others => '0');
    elsif rising_edge(clk) then
      r <= r + 1; -- monociclo: avanza 1 instrucción por ciclo
    end if;
  end process;

  pc <= r;
end architecture;
