----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity micro_processor is
Port (
    rst : in std_logic;
    clk : in std_logic;
    ALUResult : out std_logic_vector(31 downto 0);
    mem_data : out std_logic_vector(31 downto 0) );
end micro_processor;

architecture Behavioral of micro_processor is
    --FRROM FETCH-----------------
    signal instructionS : std_logic_vector(31 downto 0);
    --FRROM DECODE-----------------
    signal Instruction : std_logic_vector(31 downto 0);
    signal RegWriteAddr : std_logic_vector(4 downto 0);
    signal RegWriteData : std_logic_vector(31 downto 0);
    signal RegWriteEn : std_logic;
    signal RegWrite : std_logic;
    signal MemtoReg : std_logic;
    signal MemWrite : std_logic;
    signal ALUControl : std_logic_vector(3 downto 0);
    signal ALUSrc : std_logic;
    signal RegDst : std_logic;
    signal RD1 : std_logic_vector(31 downto 0);
    signal RD2 : std_logic_vector(31 downto 0);
    signal RtDest : std_logic_vector(4 downto 0);
    signal RdDest : std_logic_vector(4 downto 0);
    signal ImmOut : std_logic_vector(31 downto 0);
    --FRROM EXECUTE-----------------
    signal RegWrite_ex :  std_logic;
    signal MemtoReg_ex :  std_logic;
    signal MemWrite_ex :  std_logic;
    signal ALUControl_ex : std_logic_vector(3 downto 0);
    signal ALUSrc_ex : std_logic;
    signal RegDst_ex : std_logic;
    signal RD1_ex : std_logic_vector(31 downto 0);
    signal RD2_ex :  std_logic_vector(31 downto 0);
    signal RtDest_ex    : std_logic_vector(4 downto 0);
    signal RdDest_ex : std_logic_vector(4 downto 0);
    signal SignImm_ex :  std_logic_vector(31 downto 0);
    signal RegWriteOut_ex :  std_logic;
    signal MemtoRegOut_ex : std_logic;
    signal MemWriteOut_ex : std_logic;
    signal ALUResult_ex : std_logic_vector(31 downto 0);
    signal WriteData_ex : std_logic_vector(31 downto 0);
    signal WriteReg_ex : std_logic_vector(4 downto 0); 
    --FRROM MEMORY-----------------
    signal RegWrite_mem :  std_logic;
    signal MemtoReg_mem :  std_logic;
    signal WriteReg_mem : std_logic_vector(4 downto 0);
    signal MemWrite_mem :  std_logic;
    signal ALUResult_mem : std_logic_vector(31 downto 0);
    signal WriteData_mem : std_logic_vector(31 downto 0);
    signal Switches_mem : std_logic_vector(15 downto 0) := (others => '0');
    signal RegWriteOut_mem : std_logic;
    signal MemtoRegOut_mem : std_logic;
    signal WriteRegOut_mem : std_logic_vector(4 downto 0); 
    signal MemOut_mem : std_logic_vector(31 downto 0);
    signal ALUResultOut_mem : std_logic_vector(31 downto 0);
    signal ActiveDigit_mem : std_logic_vector(3 downto 0);
    signal SevenSegDigit_mem : std_logic_vector(6 downto 0);
    --FRROM WRITEBACK-----------------
    signal WriteReg_wr : std_logic_vector(4 downto 0);
    signal RegWrite_wr : std_logic;
    signal MemtoReg_wr : std_logic;
    signal ALUResult_wr : std_logic_vector(31 downto 0);
    signal ReadData_wr : std_logic_vector(31 downto 0);
    signal Result_wr : std_logic_vector(31 downto 0);
    signal WriteRegOut_wr : std_logic_vector(4 downto 0);
    signal RegWriteOut_wr :  std_logic;


begin
    fetchstage : entity work.instruction_fetch
        port map(
            clk  => clk,
            rst => rst,
            instruction => instructionS);
            
    REG1 : process(clk, rst) begin
        if rising_edge(clk) then
        Instruction <= instructionS;
        RegWriteAddr <= WriteRegOut_wr;
        RegWriteData <= Result_wr;
        RegWriteEn <= RegWriteOut_wr;
        end if;
    end process REG1;
    
    decodestage : entity work.instruction_decode
        port map (
        clk => clk,
        Instruction => Instruction,
        RegWriteAddr => RegWriteAddr,
        RegWriteData => RegWriteData,
        RegWriteEn => RegWriteEn,
        RegWrite => RegWrite,
        MemtoReg => MemtoReg,
        MemWrite => MemWrite,
        ALUControl => ALUControl,
        ALUSrc => ALUSrc,
        RegDst => RegDst,
        RD1 => RD1,
        RD2 => RD2,
        RtDest => RtDest,
        RdDest => RdDest,
        ImmOut => ImmOut
    );
    
    REG2 : process(clk, rst) begin
    if rising_edge(clk) then
        RegWrite_ex  <= RegWrite;
        MemtoReg_ex  <= MemToReg;
        MemWrite_ex  <= MemWrite;
        ALUControl_ex  <= ALUControl;
        ALUSrc_ex <= ALUSrc;
        RegDst_ex <= RegDst;
        RD1_ex <= RD1;
        RD2_ex <= RD2;
        RtDest_ex <= RtDest;
        RdDest_ex <= RdDest;
        SignImm_ex <= ImmOut;
    end if;
    end process REG2;
    
    executestage : entity work.execute_stage
        port map(
            RegWrite    => RegWrite_ex,
            MemtoReg    => MemtoReg_ex,
            MemWrite    => MemWrite_ex,
            ALUControl  => ALUControl_ex,
            ALUSrc      => ALUSrc_ex,
            RegDst      => RegDst_ex,
            RD1         => RD1_ex,
            RD2         => RD2_ex,
            RtDest      => RtDest_ex,
            RdDest      => RdDest_ex,
            SignImm     => SignImm_ex,
            RegWriteOut => RegWriteOut_ex,
            MemtoRegOut => MemtoRegOut_ex,
            MemWriteOut => MemWriteOut_ex,
            ALUResult   => ALUResult_ex,
            WriteData   => WriteData_ex,
            WriteReg    => WriteReg_ex
        );
        
    REG3 : process(clk, rst) begin
    if rising_edge(clk) then
        RegWrite_mem  <= RegWrite_ex;
        MemtoReg_mem  <= MemtoReg_ex;
        WriteReg_mem  <= WriteReg_ex;
        MemWrite_mem  <= MemWrite_ex;
        ALUResult_mem <= ALUResult_ex;
        WriteData_mem <= WriteData_ex;
    end if;
    end process REG3;
        
    memorystage : entity work.memory_stage
        port map (
            clk => clk,
            rst => rst,
            RegWrite => RegWrite_mem,
            MemtoReg => MemtoReg_mem,
            WriteReg => WriteReg_mem,
            MemWrite => MemWrite_mem,
            ALUResult => ALUResult_mem,
            WriteData => WriteData_mem,
            Switches => Switches_mem,
            RegWriteOut => RegWriteOut_mem,
            MemtoRegOut => MemtoRegOut_mem,
            WriteRegOut => WriteRegOut_mem,
            MemOut => MemOut_mem,
            ALUResultOut => ALUResultOut_mem,
            ActiveDigit => ActiveDigit_mem,
            SevenSegDigit => SevenSegDigit_mem
        );
        
    REG4 : process(clk, rst) begin
    if rising_edge(clk) then
        WriteReg_wr  <= WriteReg_mem;
        RegWrite_wr  <= RegWrite_mem;
        MemtoReg_wr  <= MemtoReg_mem;
        ALUResult_wr <= ALUResult_mem;
        ReadData_wr  <= MemOut_mem;

    end if;
    end process REG4;
        
    writebackstage : entity work.writeback_stage
        port map (
            WriteReg => WriteReg_wr,
            RegWrite => RegWrite_wr,
            MemtoReg => MemtoReg_wr,
            ALUResult => ALUResult_wr,
            ReadData => ReadData_wr,
            Result => Result_wr,
            WriteRegOut => WriteRegOut_wr,
            RegWriteOut => RegWriteOut_wr
             );
ALUResult <= ALUResult_ex;
mem_data <= Result_wr;
end Behavioral;
