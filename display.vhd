library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity display is
    Port ( entrada : in  STD_LOGIC_VECTOR(3 downto 0) ;
           saida : out  STD_LOGIC_VECTOR(13 downto 0));
end display;

architecture Behavioral of display is

begin

-- codificador para o display de 14 sementos
with entrada select saida <= 
	"10001000111111" when "0000",
	"00001000000110" when "0001",
	"00010001011011" when "0010",
	"00010000001111" when "0011",
	"00010001100110" when "0100",
	"00010001101101" when "0101",
	"00010001111101" when "0110",
	"00010000000111" when "0111",
	"00010001111111" when "1000",
	"00010001101111" when "1001",
	"00010001110111" when "1010",
	"01010100001111" when "1011",
	"00000000111001" when "1100",
	"01000100001111" when "1101",
	"00000001111001" when "1110",
	"00000001110001" when others;
	

end Behavioral;

