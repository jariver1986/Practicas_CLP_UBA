library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
  generic(
    REG_COUNT : integer := 16;
    REG_WIDTH : integer := 16
  );
  port(
    clk : in  std_logic;
    we  : in  std_logic;
    ra1 : in  std_logic_vector(3 downto 0);
    ra2 : in  std_logic_vector(3 downto 0);
    wa  : in  std_logic_vector(3 downto 0);
    wd  : in  std_logic_vector(REG_WIDTH-1 downto 0);
    rd1 : out std_logic_vector(REG_WIDTH-1 downto 0);
    rd2 : out std_logic_vector(REG_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of register_file is
  type reg_array is array (0 to REG_COUNT-1) of std_logic_vector(REG_WIDTH-1 downto 0);
  signal regs : reg_array := (others => (others => '0'));
begin
  -- Lecturas combinacionales
  rd1 <= regs(to_integer(unsigned(ra1)));
  rd2 <= regs(to_integer(unsigned(ra2)));

  -- Escritura síncrona
  process(clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        regs(to_integer(unsigned(wa))) <= wd;
      end if;
    end if;
  end process;
end architecture;
