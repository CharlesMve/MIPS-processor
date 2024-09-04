----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity execute_stage is
Port ( 
        RegWrite    : in std_logic;
        MemtoReg    : in std_logic;
        MemWrite    : in std_logic;
        ALUControl    : in std_logic_vector(3 downto 0);
        ALUSrc    : in std_logic;
        RegDst    : in std_logic;
        RD1    : in std_logic_vector(31 downto 0);
        RD2    : in std_logic_vector(31 downto 0);
        RtDest    : in std_logic_vector(4 downto 0);
        RdDest    : in std_logic_vector(4 downto 0);
        SignImm    : in std_logic_vector(31 downto 0);
        RegWriteOut : out std_logic;
        MemtoRegOut : out std_logic;
        MemWriteOut: out std_logic;
        ALUResult : out std_logic_vector(31 downto 0);
        WriteData : out std_logic_vector(31 downto 0);
        WriteReg : out std_logic_vector(4 downto 0)); 
        
end execute_stage;

architecture Behavioral of execute_stage is
    signal ALUResultSig : std_logic_vector(31 downto 0);
    signal B : std_logic_vector(31 downto 0);
begin
    aluN : entity work.alu4
       port map(
            A => RD1,
            B => B,
            Control => ALUControl,
            out1 => ALUResultSig);
    RegWriteOut <= RegWrite;
    MemtoRegOut <= MemtoReg;
    MemWriteOut <= MemWrite;
    ALUResult <= ALUResultSig;
    WriteData <= RD2;
    process(RegDst, RtDest, RdDest) is begin
        if RegDst = '0' then
            WriteReg <= RtDest;
        else
            WriteReg <= RdDest;
        end if;
    end process;
    process(ALUSrc, SignImm, RD2) is begin
        if ALUSrc = '1' then
            B <= SignImm;
        else
            B <= RD2;
        end if;
   end process;
end Behavioral;
