library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
  generic(W : integer := 16);
  port(
    a : in  std_logic_vector(W-1 downto 0);
    b : in  std_logic_vector(W-1 downto 0);
    s : in  std_logic;
    y : out std_logic_vector(W-1 downto 0)
  );
end entity;

architecture rtl of mux2 is
begin
  y <= b when s='1' else a;
end architecture;
