library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory_stage is
    generic (
        WIDTH : integer := 32;
        ADDR_SPACE : integer := 10
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        RegWrite : in std_logic;
        MemtoReg : in std_logic;
        WriteReg : in std_logic_vector(4 downto 0);
        MemWrite : in std_logic;
        ALUResult : in std_logic_vector(31 downto 0);
        WriteData : in std_logic_vector(31 downto 0);
        Switches : in std_logic_vector(15 downto 0);
        
        RegWriteOut : out std_logic;
        MemtoRegOut : out std_logic;
        WriteRegOut : out std_logic_vector(4 downto 0);
        MemOut : out std_logic_vector(31 downto 0);
        ALUResultOut : out std_logic_vector(31 downto 0);
        ActiveDigit : out std_logic_vector(3 downto 0);
        SevenSegDigit : out std_logic_vector(6 downto 0)
    );
end entity memory_stage;

architecture Behavioral of memory_stage is
    -- Declare any internal signals or components here
    signal seven_seg_digit : std_logic_vector(6 downto 0);
    signal active_digit : std_logic_vector(3 downto 0);
    signal mem_to_controller : std_logic_vector(15 downto 0);
begin
     data_mem : entity work.data_memory
        generic map (WIDTH => WIDTH, ADDR_SPACE => ADDR_SPACE)
        port map(
            clk => clk,
            w_en => MemWrite,
            addr => ALUResult(ADDR_SPACE-1 downto 0),
            d_in => WriteData,
            d_out => MemOut,
            switches => Switches,
            seven_seg => mem_to_controller);
    seven_seg : entity work.SevenSegController
        port map(
            clk => clk,
            rst => rst,
            display_number => mem_to_controller,
            active_segment => active_digit,
            led_out => seven_seg_digit);

            
            RegWriteOut <= RegWrite;
            MemtoRegOut <= MemtoReg;
            WriteRegOut <= WriteReg;
            ALUResultOut <= ALUResult;
            ActiveDigit <= active_digit;
            SevenSegDigit <= seven_seg_digit;
            
end architecture Behavioral;
