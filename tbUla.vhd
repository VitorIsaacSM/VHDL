
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
 
ENTITY tbUla IS
END tbUla;
 
ARCHITECTURE behavior OF tbUla IS 

signal a, b: std_logic_vector(7 downto 0) := (others => '0');
signal H, L: std_logic_vector(13 downto 0) := (others => '0');
signal sel: std_logic_vector(2 downto 0) := (others => '0');
signal z,c,v,n: std_logic;
   
begin
	
	process
	begin
		a <= a + 3 after 16 ns;
		wait for 16 ns;
	end process;
	
		process
	begin
		b <= b + 3 after 1 ns;
		wait for 1 ns;
	end process;
	
	process
	begin
		sel <= sel + 1 after 128 ns;
		wait for 128 ns;
	end process;
		
	ula: entity work.ULA port map(opa => a, opb => b, sel => sel, H => H, L => L, C => c, Z => z, N => n, V => v);

END;
