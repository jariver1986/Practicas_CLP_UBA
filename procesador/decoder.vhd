library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
  port(
    instr : in  std_logic_vector(15 downto 0);
    opcode: out std_logic_vector(3 downto 0);
    rd    : out unsigned(3 downto 0);
    rs    : out unsigned(3 downto 0);
    rt    : out unsigned(3 downto 0)
  );
end entity;

architecture rtl of decoder is
begin
  opcode <= instr(15 downto 12);
  rd     <= unsigned(instr(11 downto 8));
  rs     <= unsigned(instr(7  downto 4));
  rt     <= unsigned(instr(3  downto 0));
end architecture;
