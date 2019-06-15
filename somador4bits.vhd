
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity somador4bits is
    Port ( a : in  STD_LOGIC_VECTOR(3 downto 0);  -- entrada A do somador
           b : in  STD_LOGIC_VECTOR(3 downto 0);  -- entrada B do somador
           cin : in  STD_LOGIC;                   -- carry de entrada do somador
			  cbefore: out std_logic;					  -- penultimo carry(c(2))
           cout : out  STD_LOGIC;                 -- carry out
           s : out  STD_LOGIC_VECTOR(3 downto 0)  -- saida
			  );
end somador4bits;

architecture Behavioral of somador4bits is
	signal g,p: std_logic_vector(3 downto 0);      --carry gerado(g), e carry propagado(p)
	signal co: std_logic_vector(2 downto 0);		  -- carries que vao para cada Full adder

begin

	--pgGenerator recebe a e b, e retorna o valor gerado(g) e propagado(p)
	pg0: entity work.pgGenerator port map(a => a(0), b => b(0), p => p(0), g => g(0));
	pg1: entity work.pgGenerator port map(a => a(1), b => b(1), p => p(1), g => g(1));
	pg2: entity work.pgGenerator port map(a => a(2), b => b(2), p => p(2), g => g(2));
	pg3: entity work.pgGenerator port map(a => a(3), b => b(3), p => p(3), g => g(3));
	
	
	
	-- carrys gerados a partir da logica de propagacao rapida
	co(0) <= ( cin and p(0)) or g(0);
	co(1) <= (p(1) and p(0) and cin) or (p(1) and g(0)) or(g(1));
	co(2) <= (p(0) and p(1) and p(2) and cin) or (p(2) and p(1) and g(0)) or (p(2) and g(1)) or (g(2));
	
	
	-- full adders
	fa1: entity work.somador port map(a => a(0), b => b(0), cin => cin, s => s(0));
	fa2: entity work.somador port map(a => a(1), b => b(1), cin => co(0), s => s(1));
	fa3: entity work.somador port map(a => a(2), b => b(2), cin => co(1), s => s(2));
	fa4: entity work.somador port map(a => a(3), b => b(3), cin => co(2), s => s(3));
	
	-- carry out final
	cout <= (p(3) and p(2) and p(1) and p(0) and cin) or 
	        (p(3) and p(2) and p(1) and g(0)) or 
			  (p(3) and p(2) and g(1)) or
			  (g(2) and p(3)) or 
			  (g(3));
	
	-- penultimo carry
	cbefore <= co(2);

end Behavioral;

