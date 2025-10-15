library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Opcode map:
-- 0000 NOP
-- 0001 ADD
-- 0010 SUB
-- 0011 ADDI (imm4 sign-extend)
-- 0100 SUBI (imm4 sign-extend)
-- 0101 MOV  (rd := rs)  -- rt ignorado

entity control_unit is
  port(
    instr   : in  std_logic_vector(15 downto 0);
    reg_wen : out std_logic;
    use_imm : out std_logic;
    alu_sel : out std_logic_vector(1 downto 0)  -- "00" add, "01" sub, "10" movA, "11" zero
  );
end entity;

architecture rtl of control_unit is
  signal op : std_logic_vector(3 downto 0);
begin
  op <= instr(15 downto 12);

  process(op)
  begin
    -- valores por defecto (NOP)
    reg_wen <= '0';
    use_imm <= '0';
    alu_sel <= "11"; -- zero

    case op is
      when "0000" => -- NOP
        reg_wen <= '0';
        use_imm <= '0';
        alu_sel <= "11";
      when "0001" => -- ADD rd := rs + rt
        reg_wen <= '1';
        use_imm <= '0';
        alu_sel <= "00";
      when "0010" => -- SUB rd := rs - rt
        reg_wen <= '1';
        use_imm <= '0';
        alu_sel <= "01";
      when "0011" => -- ADDI rd := rs + imm4
        reg_wen <= '1';
        use_imm <= '1';
        alu_sel <= "00";
      when "0100" => -- SUBI rd := rs - imm4
        reg_wen <= '1';
        use_imm <= '1';
        alu_sel <= "01";
      when "0101" => -- MOV rd := rs
        reg_wen <= '1';
        use_imm <= '0';
        alu_sel <= "10"; -- movA
      when others =>
        reg_wen <= '0';
        use_imm <= '0';
        alu_sel <= "11";
    end case;
  end process;
end architecture;
