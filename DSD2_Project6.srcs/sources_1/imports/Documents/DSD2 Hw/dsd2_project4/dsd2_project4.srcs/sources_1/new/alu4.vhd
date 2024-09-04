----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2024 02:45:51 PM
-- Design Name: 
-- Module Name: alu4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu4 is
GENERIC ( N : INTEGER := 32;
          M : INTEGER := 5
) ; -- bit width
Port (
        A : in std_logic_vector(N-1 downto 0);
        B : in std_logic_vector(N-1 downto 0);
        control : in std_logic_vector(3 downto 0);
        out1 : out std_logic_vector(N-1 downto 0) );
end alu4;

architecture Behavioral of alu4 is 
    signal not_result : std_logic_vector (N-1 downto 0) ;
    signal sll_result : std_logic_vector (N-1 downto 0) ;
    signal and_result : std_logic_vector (N-1 downto 0) ;
    signal or_result : std_logic_vector (N-1 downto 0) ;
    signal xor_result : std_logic_vector (N-1 downto 0) ;
    signal srl_result : std_logic_vector (N-1 downto 0) ;
    signal sra_result : std_logic_vector (N-1 downto 0) ;
    signal sproduct : std_logic_vector(N-1 downto 0);
    signal ssum_add : std_logic_vector(N-1 downto 0);
    signal ssum_sub : std_logic_vector(N-1 downto 0);
    signal OP : std_logic;
    
    signal internal_out : std_logic_vector(N-1 downto 0);
begin
    ripple_carry : entity work.ripple_carry
    Generic map ( N => N )
       port map(
            A => A,
            B => B,
            OP => '0',
            sum => ssum_add);
        ripple_carry2 : entity work.ripple_carry
         Generic map ( N => N )
       port map(
            A => A,
            B => B,
            OP => '1',
            sum => ssum_sub);
            
    multiplier : entity work.multiplier
        port map(
            A => A(((N/2)-1) downto 0),
            B => B(((N/2)-1) downto 0),
            product => sproduct);
not_comp : entity work.notN
generic map ( N => N )
port map ( A => A , Y => not_result ) ;
sll_comp : entity work.sllN
generic map ( N => N , M => M )
port map ( A => A , SHIFT_AMT => B (M -1 downto 0) , Y => sll_result ) ;
srl_comp : entity work.srlN
generic map ( N => N , M => M )
port map ( A => A , SHIFT_AMT => B (M -1 downto 0) , Y => srl_result ) ;
sra_comp : entity work.sraN
generic map ( N => N , M => M )
port map ( A => A , SHIFT_AMT => B (M -1 downto 0) , Y => sra_result ) ;
--
and_comp : entity work.log_and
generic map ( N => N )
port map ( A => A, B => B, Y => and_result);
or_comp : entity work.log_or
generic map ( N => N )
port map ( A => A, B => B, Y => or_result);
xor_comp : entity work.log_xor
generic map ( N => N )
port map ( A => A, B => B, Y => xor_result);

internal_out <=    and_result when control = "1010" else
        ssum_sub when control = "0101" else
        ssum_add when control = "0100" else
        sproduct when control = "0110" else
        or_result when control = "1000"  else
        xor_result when control = "1011" else
        sra_result when control = "1110" else
        srl_result when control = "1101" else
        sll_result when control = "1100" else  
        not_result ;
        
out1 <= internal_out;

end Behavioral;
