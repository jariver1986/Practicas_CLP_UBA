library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imm_gen is
  port(
    instr : in  std_logic_vector(15 downto 0);
    imm16 : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of imm_gen is
  signal imm4 : std_logic_vector(3 downto 0);
begin
  imm4  <= instr(3 downto 0);
  -- Sign-extend de 4 a 16 bits
  imm16 <= (15 downto 4 => imm4(3)) & imm4;
end architecture;
