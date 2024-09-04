-------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity control_unit is
Port ( 
    opcode :    in std_logic_vector(5 downto 0);
    funct   :   in std_logic_vector(5 downto 0);
    regwrite:   out std_logic;
    memtoreg:   out std_logic;
    memwrite:   out std_logic;
    ALUControl: out std_logic_vector(3 downto 0);
    ALUSrc  :   out std_logic;
    regDst  :   out std_logic);
end control_unit;

architecture Behavioral of control_unit is

begin

process(opcode) is begin --ask ren bout this
    if opcode = "000000" or opcode = "001000" or opcode = "001100" or opcode = "001101" or opcode = "001110" or opcode = "100011" then
        regwrite <= '1';
    else
        regwrite <= '0';
    end if;
end process;

process(opcode) is begin
    if opcode = "100011" then
        memtoreg <= '1';
    else
        memtoreg <= '0';
    end if;
end process;

process(opcode) is begin
    if opcode = "101011" then
        memwrite <= '1';
    else 
        memwrite <= '0';
    end if;
end process;

process(opcode, funct) is begin
    if opcode = "000000" then
        case funct is
            when "100000" => ALUControl <= "0100";
            when "100100" => ALUControl <= "1010";
            when "011001" => ALUControl <= "0110";
            when "100101" => ALUControl <= "1000";
            when "000000" => ALUControl <= "1100";
            when "000011" => ALUControl <= "1110";
            when "000010" => ALUControl <= "1101";
            when "100010" => ALUControl <= "0101";
            when "100110" => ALUControl <= "1011";
            when others => ALUControl <= "0000";
        end case;
     else
        case opcode is
            when "001000" => ALUControl <= "0100";
            when "001100" => ALUControl <= "1010";
            when "001101" => ALUControl <= "1000";
            when "001110" => ALUControl <= "1011";
            when "101011" => ALUControl <= "0100";
            when "100011" => ALUControl <= "0100";
            when others => ALUControl <= "0000";
        end case;
     end if;
end process;

process(opcode) is begin
    if opcode = "000000" then
        ALUSrc <= '0';
    else
        ALUSrc <= '1';
    end if;
end process;

process(opcode) is begin
    if opcode = "000000" then
        RegDst <= '1';
    else
        RegDst <= '0';
    end if;
end process;

end Behavioral;
