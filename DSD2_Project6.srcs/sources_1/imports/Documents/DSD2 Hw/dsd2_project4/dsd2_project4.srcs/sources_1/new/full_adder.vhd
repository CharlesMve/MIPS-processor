-------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity full_adder is
 Generic ( N : integer := 32 );
Port ( 
        A : in std_logic;
        B : in std_logic;
        OP : in std_logic;
        Cout : out std_logic;
        sum: out std_logic);
end full_adder;

architecture Behavioral of full_adder is
    signal B_sig : std_logic;
begin
            --B_sig <= B XOR OP;
            sum <= (A xor B) xor OP;
            Cout <= (A AND B) OR (OP AND A) OR (OP AND B);
            -- <= (xor result and OP) or (A and B)
end Behavioral;
