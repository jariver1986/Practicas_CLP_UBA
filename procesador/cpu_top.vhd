library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_top is
  port(
    clk      : in  std_logic;
    rst      : in  std_logic;
    gpio_out : out std_logic_vector(15 downto 0)  -- libre para LEDs/pines
  );
end entity;

architecture rtl of cpu_top is
  -- Señales de interconexión
  signal pc_val      : unsigned(15 downto 0);
  signal instr       : std_logic_vector(15 downto 0);
  signal rd, rs, rt  : unsigned(3 downto 0);
  signal imm_sext    : std_logic_vector(15 downto 0);
  signal reg_wen     : std_logic;
  signal use_imm     : std_logic;
  signal alu_sel     : std_logic_vector(1 downto 0); -- "00" add, "01" sub, "10" movA, "11" zero
  signal ra, rb      : std_logic_vector(15 downto 0);
  signal alu_b       : std_logic_vector(15 downto 0);
  signal alu_y       : std_logic_vector(15 downto 0);
begin
  -- PC
  u_pc: entity work.pc
    port map(
      clk => clk, rst => rst, pc => pc_val
    );

  -- Memoria de instrucciones (ROM)
  u_imem: entity work.instr_mem
    port map(
      addr  => std_logic_vector(pc_val),
      instr => instr
    );

  -- Decodificador de campos
  u_dec: entity work.decoder
    port map(
      instr => instr,
      opcode=> open,
      rd    => rd,
      rs    => rs,
      rt    => rt
    );

  -- Unidad de control
  u_ctl: entity work.control_unit
    port map(
      instr   => instr,
      reg_wen => reg_wen,
      use_imm => use_imm,
      alu_sel => alu_sel
    );

  -- Generador de inmed.
  u_imm: entity work.imm_gen
    port map(
      instr => instr,
      imm16 => imm_sext
    );

  -- Banco de registros
  u_rf: entity work.register_file
    port map(
      clk => clk,
      we  => reg_wen,
      ra1 => std_logic_vector(rs),
      ra2 => std_logic_vector(rt),
      wa  => std_logic_vector(rd),
      wd  => alu_y,
      rd1 => ra,
      rd2 => rb
    );

  -- Selección operando B
  alu_b <= imm_sext when use_imm='1' else rb;

  -- ALU
  u_alu: entity work.alu
    port map(
      a       => ra,
      b       => alu_b,
      alu_sel => alu_sel,
      y       => alu_y
    );

  -- Salida de propósito general (observación)
  gpio_out <= alu_y;  -- puedes cambiar a registrar X si prefieres
end architecture;
