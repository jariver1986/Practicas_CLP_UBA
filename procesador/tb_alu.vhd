library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu is end;
architecture sim of tb_alu is
  signal a,b,y : std_logic_vector(15 downto 0);
  signal sel   : std_logic_vector(1 downto 0);
begin
  uut: entity work.alu port map(a=>a, b=>b, alu_sel=>sel, y=>y);

  process
  begin
    -- ADD 3 + 5 = 8
    a <= x"0003"; b <= x"0005"; sel <= "00"; wait for 10 ns;
    assert y = x"0008" report "ADD fallo" severity error;

    -- SUB 9 - 4 = 5
    a <= x"0009"; b <= x"0004"; sel <= "01"; wait for 10 ns;
    assert y = x"0005" report "SUB fallo" severity error;

    -- MOV_A
    a <= x"00AA"; b <= x"5555"; sel <= "10"; wait for 10 ns;
    assert y = x"00AA" report "MOV_A fallo" severity error;

    -- ZERO
    sel <= "11"; wait for 10 ns;
    assert y = x"0000" report "ZERO fallo" severity error;

    report "tb_alu OK" severity note;
    wait;
  end process;
end architecture;
