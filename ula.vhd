library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ULA is
    Port ( opa, opb : in  STD_LOGIC_VECTOR(7 downto 0);  -- Entradas A e B
           sel : in  STD_LOGIC_VECTOR(2 downto 0);       -- Seletor
           H, L: out STD_LOGIC_VECTOR(13 downto 0);      -- Saidas High e Low codificadas
			  Z, N, C, V: out STD_LOGIC );                  -- Qualificadores
end ULA;


architecture Behavioral of ULA is

signal nopb: std_logic_vector(7 downto 0);   -- nopb é a negacao da entrada opb
signal ropb: std_logic_vector(7 downto 0);   -- ropb pode ser nopb ou opb, e é passado para os somadores
 
signal co: std_logic_vector(1 downto 0);     -- co(0) e co(1) sao respectivamente, os carrys finais de cada somador

signal cbefore: std_logic;                -- cbefore é o penultimo carry do somador2, usado para calcular o overflow
signal overflow: std_logic;               -- overflow recebe o valor de overflow que sera passado para a saida V

signal output: std_logic_vector(7 downto 0);  -- output recebe a saida de 8 bits de qualquer operacao realizada

signal somada: std_logic_vector(7 downto 0);  -- somada recebe o resultado que sai do somador (para soma e subtraçao)

signal naoOu, exOr, naoE: std_logic_vector(7 downto 0); -- resultados das operacoes logicas, naoOu, exOr, naoE

signal paridade: std_logic_vector(7 downto 0) := (others => '0'); -- resultado da operacao paridade

signal carrySel: std_logic;  -- carrySel é o Cin do somador1, sendo '1' quando a operacao for subtracao 

begin

naoOu <= not(opa or opb);

exOr  <= opa xor opb;

naoE  <= not(opa and opb);

paridade(0) <= opa(0) xor opa(1) xor opa(2) xor opa(3) xor opa(4) xor opa(5) xor opa(6) xor opa(7);

nopb <= not opb;


-- seleciona o valor de ropb, que sera passado para os somadores
with sel select ropb <=
	opb when "000",
	nopb when "001";
	
-- seleciona o valor do carry de entrada do somador1, '1' para operacao de subtracao e '0' para a de soma
with sel select carrySel <=
	'0' when "000",
	'1' when "001";
	
	
-- overflow recebe o valor de uma XOR entre o carry final e o penultimo carry(cbefore)
-- quando for selecionada uma operacao que use somadores (soma ou subtracao).
-- e recebe '0' para qualquer outra operacao
overflow <= (co(1) xor cbefore) when (sel = "001" or sel = "000") else
		'0';

V <= overflow;  -- V recebe o valor de overflow
	  
N <= output(7); -- N recebe o bit de sinal da saida

-- Z recebe '1' quando a saida for 0, e '0' em qualquer outro caso
Z <= '1' when output = "00000000" else  
	  '0';
	  
	  
-- C recebe co(1), que é o carryOut do somador2, quando a o operacao
-- for uma operacao de soma ou subtracao. e '0' em outros casos
C <= co(1) when sel = "000" else
	  co(1) when sel = "001" else
	  '0';


-- somadores
somador1: entity work.somador4bits port map(a => opa(3 downto 0), b => ropb(3 downto 0), cin => carrySel, s => somada(3 downto 0), cout => co(0) );	
somador2: entity work.somador4bits port map(a => opa(7 downto 4), b => ropb(7 downto 4), cin => co(0), s => somada(7 downto 4), cout => co(1), cbefore => cbefore);


-- seleciona o que output vai receber com base no que foi passado para o seletor
with sel select output <= 
	somada when "000",
	somada when "001",
	((not opa)+ 1) when "010",
	paridade when "011",
	(not opa) when "100",
	naoOu when "101",
	exOr when "110",
	naoE when "111";
	

-- passa o resultado de output para os codificadores do display de 14 segmentos
codH: entity work.display port map(entrada => output(7 downto 4), saida => H);
codL: entity work.display port map(entrada => output(3 downto 0), saida => L);

end Behavioral;

