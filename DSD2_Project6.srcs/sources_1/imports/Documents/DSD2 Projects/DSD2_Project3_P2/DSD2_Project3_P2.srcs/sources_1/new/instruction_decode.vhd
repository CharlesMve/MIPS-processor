----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity instruction_decode is
GENERIC(
		BIT_WIDTH : integer := 32;
		LOG_PORT_DEPTH : integer := 5
	);
 Port ( 
        clk : in std_logic;
        Instruction : in std_logic_vector(31 downto 0);
        RegWriteAddr : in std_logic_vector(4 downto 0);
        RegWriteData : in std_logic_vector(31 downto 0);
        RegWriteEn   : in std_logic;
        RegWrite    : out std_logic;
        MemtoReg    : out std_logic;
        MemWrite    : out std_logic;
        ALUControl    : out std_logic_vector(3 downto 0);
        ALUSrc    : out std_logic;
        RegDst    : out std_logic;
        RD1    : out std_logic_vector(31 downto 0);
        RD2    : out std_logic_vector(31 downto 0);
        RtDest    : out std_logic_vector(4 downto 0);
        RdDest    : out std_logic_vector(4 downto 0);
        ImmOut    : out std_logic_vector(31 downto 0));
end instruction_decode;

architecture Behavioral of instruction_decode is
begin
    control_unit : entity work.Control_Unit
        port map(
            opcode => Instruction(31 downto 26),
            funct => Instruction(5 downto 0),
            regwrite => RegWrite,
            memtoreg => MemtoReg,
            memwrite => MemWrite,
            ALUControl => ALUControl,
            ALUSrc => ALUSrc,
            regDst => RegDst);
            
    reg_file : entity work.reg_file
        port map(
            Addr1 => Instruction(25 downto 21),
            Addr2 => Instruction(20 downto 16),
            Addr3 => RegWriteAddr,
            wd => RegWriteData,
            we => RegWriteEn,
            RD1 => RD1,
            RD2 => RD2,
            clk_n => clk);
            
RtDest <= Instruction(20 downto 16);
RdDest <= Instruction(15 downto 11);
ImmOut(15 downto 0) <= Instruction(15 downto 0);
ImmOut(31 downto 16) <= (others => (Instruction(15)));


end Behavioral;
