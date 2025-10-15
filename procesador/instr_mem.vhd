library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ROM de instrucciones. Para síntesis, modifica "prog" según necesites.
-- Formato: [15:12]=op, [11:8]=rd, [7:4]=rs, [3:0]=rt/imm4 (sign-extend)
entity instr_mem is
  port(
    addr  : in  std_logic_vector(15 downto 0);
    instr : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of instr_mem is
  constant DEPTH : integer := 256;
  type rom_t is array (0 to DEPTH-1) of std_logic_vector(15 downto 0);

  -- Programa demo (se usa en tb_cpu_top; también sirve para síntesis)
  -- r1 := 0x0003  (via ADDI r1 = r0 + 3)
  -- r2 := 0x0005  (via ADDI r2 = r0 + 5)
  -- r3 := r1 + r2
  -- r4 := r3 - 1
  -- NOPs finales
  constant prog : rom_t := (
    0 => "0011" & "0001" & "0000" & "0011", -- ADDI r1, r0, +3
    1 => "0011" & "0010" & "0000" & "0101", -- ADDI r2, r0, +5
    2 => "0001" & "0011" & "0001" & "0010", -- ADD  r3, r1, r2
    3 => "0100" & "0100" & "0011" & "0001", -- SUBI r4, r3, 1
    4 => "0101" & "0101" & "0100" & "0000", -- MOV  r5, r4
    5 => "0000" & "0000" & "0000" & "0000", -- NOP
    6 => "0000" & "0000" & "0000" & "0000", -- NOP
    others => (others => '0')
  );

begin
  instr <= prog(to_integer(unsigned(addr(7 downto 0)))); -- 256 palabras
end architecture;
