----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2024 02:52:17 PM
-- Design Name: 
-- Module Name: microprocessor_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity microprocessor_tb is
end microprocessor_tb;

architecture Behavioral of microprocessor_TB is

--
    function vec2str(vec: std_logic_vector) return string is
        variable stmp: string(vec'high+1 downto 1);
        variable counter : integer := 1;
    begin
        for i in vec'reverse_range loop
            stmp(counter) := std_logic'image(vec(i))(2); -- image returns '1' (with quotes)
            counter := counter + 1;
        end loop;
        return stmp;
    end vec2str;
--


component micro_processor
  port (
    clk : in std_logic;
    rst : in std_logic;
    ALUResult : out std_logic_vector(31 DOWNTO 0);
    mem_data : out std_logic_vector(31 downto 0)
  );
end component;

	signal rst : std_logic := '0';
	signal clk : std_logic;
	signal ALUResult : std_logic_vector(31 downto 0);
	signal mem_data : std_logic_vector(31 downto 0);


begin

uut : micro_processor
  port map (
    clk => clk,
    rst => rst,
    ALUResult => ALUResult,
    mem_data => mem_data
  );

clk_proc:process
begin
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
end process;

stim_proc:process
begin

		wait until clk='0';
		wait for 5 ns;
--TODO:	assert statement
	 assert ALUResult = x"20210001" report "Error: ALUResult is " & vec2str(ALUResult)& " Expected: 00211020";
	wait;

	assert false
		report "Testbench Concluded"
		severity failure;


end process;

end Behavioral;