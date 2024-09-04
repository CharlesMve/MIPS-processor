
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity multiplier is
 Generic ( N : integer := 32 );
Port ( 
        A : in std_logic_vector((N/2)-1 downto 0);
        B : in std_logic_vector((N/2)-1 downto 0);
        product: out std_logic_vector(N-1 downto 0));
end multiplier;

architecture Behavioral of multiplier is
type partial_product is array (0 to (N/2)-1) of std_logic_vector((N/2)-1 downto 0);
signal par_prod : partial_product := (others => (others => '0'));
signal carries : partial_product := (others => (others => '0'));
signal sums : partial_product := (others => (others => '0'));

begin

    first:
    for col in 0 to (N/2)-1 generate
        sums(0)(col) <= A(col) and B(0);
    end generate first;
    products:
    for row in 1 to (N/2) - 1 generate
        products2:
        for col in 0 to (N/2) - 1 generate
            par_prod(row)(col) <= A(col) and B(row);
            ifcol:
            if col = 0 generate
                full_adder1 : entity work.full_adder
                port map (A => par_prod(row)(col), B => sums(row-1)(col+1), 
                OP => '0', Cout => carries(row)(col), Sum => sums(row)(col));
                product(row) <= sums(row)(0);
            end generate ifcol;
            ifcol1to3:
            if col > 0 and col < ((N/2)-1) generate
                full_adder2 : entity work.full_adder
                port map (A => par_prod(row)(col), B => sums(row-1)(col+1), 
                OP => carries(row)(col-1), Cout => carries(row)(col), Sum => sums(row)(col));
            end generate ifcol1to3;
            ifcol3:
            if col = (N/2)-1 generate
                full_adder3 : entity work.full_adder
                port map (A => par_prod(row)(col), B => carries(row-1)(col), 
                OP => carries(row)(col-1), Cout => carries(row)(col), Sum => sums(row)(col));
            end generate ifcol3;
         end generate products2;
    end generate products;


product(0) <= sums(0)(0);
product(N-2 downto (N/2)) <= sums((N/2)-1)((N/2)-1 downto 1);
product(N-1) <= carries((N/2)-1)((N/2)-1);

end Behavioral;
