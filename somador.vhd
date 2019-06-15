
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity somador is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC
			  );
end somador;

architecture Behavioral of somador is
begin
	-- somador simples que tem como saida apenas o resultado da soma (sem carry)
	s <= a xor b xor cin;
	
end Behavioral;

