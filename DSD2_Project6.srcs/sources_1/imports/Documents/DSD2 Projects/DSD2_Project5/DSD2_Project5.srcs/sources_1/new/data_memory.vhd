library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    generic (
        WIDTH : integer := 32;
        ADDR_SPACE : integer := 10
    );
    port (
        CLK : in std_logic;
        W_EN : in std_logic;
        ADDR : in std_logic_vector(ADDR_SPACE-1 downto 0);
        D_IN : in std_logic_vector(WIDTH-1 downto 0);
        D_OUT : out std_logic_vector(WIDTH-1 downto 0);
        SWITCHES : in std_logic_vector(15 downto 0);
        SEVEN_SEG : out std_logic_vector(15 downto 0)
    );
end entity data_memory;

architecture Behavioral of data_memory is
    type mem_array is array (0 to 2**ADDR_SPACE - 1) of std_logic_vector(WIDTH-1 downto 0);
    signal mips_mem : mem_array  := (others => (others => '0'));
begin
    process(CLK)
    begin
        if falling_edge(CLK) then
            if W_EN = '1' then
                mips_mem(to_integer(unsigned(ADDR))) <= D_IN;
            end if;
            
            if to_integer(unsigned(ADDR)) = 1023 then
                if W_EN = '1' then
                    SEVEN_SEG <= D_IN(15 downto 0);
                end if;
            elsif to_integer(unsigned(ADDR)) = 1022 then
                D_OUT <= (x"0000" & SWITCHES);
            else
                D_OUT <= mips_mem(to_integer(unsigned(ADDR)));
            end if;
        end if;
    end process;
end architecture Behavioral;