--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_fetch is
Port ( 
    clk :   in std_logic;
    rst :   in std_logic;
    instruction :   out std_logic_vector (31 downto 0));
end instruction_fetch;

architecture Behavioral of instruction_fetch is 
    signal addrS : std_logic_vector(27 downto 0) := (others => '0');
    signal d_outS : std_logic_vector(31 downto 0);

begin
    instrMem : entity work.instruction_mem
        port map(
            addr => addrS,
            d_out => d_outS);
process(clk, rst)
begin
    if (rst = '1') then
        addrS <= (others => '0');
    elsif rising_edge(clk) then
        addrS <= std_logic_vector(unsigned(addrS) +4);
    end if;
   end process;

    instruction <= d_outS;

end Behavioral;