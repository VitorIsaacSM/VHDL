library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pgGenerator is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           p : out  STD_LOGIC;
           g : out  STD_LOGIC);
end pgGenerator;

architecture Behavioral of pgGenerator is

begin

-- define a geraçao e propagacao de carry 
g <= a and b;
p <= a or b;

end Behavioral;

