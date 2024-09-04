-------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ripple_carry is
 Generic ( N : integer := 32 );
Port ( 
        A : in std_logic_vector(N-1 downto 0);
        B : in std_logic_vector(N-1 downto 0);
        OP : in std_logic;
        sum: out std_logic_vector(N-1 downto 0));
end ripple_carry;

architecture Behavioral of ripple_carry is
type carries is array (0 to N-1) of std_logic;
    signal ssum : std_logic_vector(N-1 downto 0);
    signal carry: carries := (others => '0');
    signal Bsig : std_logic_vector(N-1 downto 0);
begin
    gen1:
    for i in 0 to N-1 generate
        Bsig(i) <= B(i) XOR OP;
    end generate;
    full_adder : entity work.full_adder
    port map (A => A(0), B => Bsig(0), OP => OP, Cout => Carry(0), Sum => ssum(0));
    ripple:
    for I in 1 to (N-1) generate
    full_adder : entity work.full_adder
    port map (A => A(I), B => Bsig(I), OP => carry(I-1),
     Cout => Carry(I), Sum => ssum(I));
end generate ripple;
sum <= ssum;

end Behavioral;
