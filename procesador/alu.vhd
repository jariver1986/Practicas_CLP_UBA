library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- alu_sel: "00"=ADD, "01"=SUB, "10"=MOV_A, "11"=ZERO
entity alu is
  port(
    a       : in  std_logic_vector(15 downto 0);
    b       : in  std_logic_vector(15 downto 0);
    alu_sel : in  std_logic_vector(1 downto 0);
    y       : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of alu is
  signal a_u, b_u : signed(15 downto 0);
  signal res      : signed(15 downto 0);
begin
  a_u <= signed(a);
  b_u <= signed(b);

  process(a_u, b_u, alu_sel)
  begin
    case alu_sel is
      when "00" => res <= a_u + b_u;
      when "01" => res <= a_u - b_u;
      when "10" => res <= a_u;       -- MOV_A
      when others => res <= (others => '0');
    end case;
  end process;

  y <= std_logic_vector(res);
end architecture;
