-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
library IEEE ;
use IEEE . STD_LOGIC_1164 . ALL ;
use IEEE . NUMERIC_STD . ALL ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_file is
GENERIC(
		BIT_WIDTH : integer := 32;
		LOG_PORT_DEPTH : integer := 5
	);
port (
Addr1, Addr2, Addr3 : in std_logic_vector (LOG_PORT_DEPTH-1 downto 0);
wd : in std_logic_vector (BIT_WIDTH-1 downto 0);
clk_n, we : in std_logic;
RD1, RD2 : out std_logic_vector (BIT_WIDTH-1 downto 0));
end reg_file;

architecture Behavioral of reg_file is
type mem_type is array (2 ** LOG_PORT_DEPTH -1 downto 0) of std_logic_vector(BIT_WIDTH-1 downto 0);
signal registerArray_sig : mem_type := (others => (others => '0'));

begin
process (clk_n, addr3)
    begin
        if falling_edge(clk_n) then
            if we = '1' and (to_integer(unsigned(addr3))) /= 0 then
                registerArray_sig(to_integer(unsigned(addr3))) <= wd;
            end if;
         end if;
   end process;
    RD1 <= registerArray_sig(to_integer(unsigned(addr1)));
    RD2 <= registerArray_sig(to_integer(unsigned(addr2)));
end Behavioral;
