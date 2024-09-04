----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2024 11:39:27 AM
-- Design Name: 
-- Module Name: srlN - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity srlN is
GENERIC ( N : INTEGER := 32; -- bit width
          M : INTEGER := 5) ; -- shift bits
    PORT (
            A : IN std_logic_vector (N -1 downto 0) ;
            SHIFT_AMT : IN std_logic_vector (M -1 downto 0) ;
            Y : OUT std_logic_vector (N -1 downto 0)
           ) ;
end srlN ;

architecture behavioral of srlN is
    -- create array of vectors to hold each of n shifters
        type shifty_array is array (N -1 downto 0) of std_logic_vector (N -1
            downto 0) ;
        signal aSLL : shifty_array ;

begin
    generateSLL : for i in 0 to N -1 generate
        aSLL ( i ) (N -1 - i downto 0 ) <= A (N -1 downto i) ;
        right_fill : if i > 0 generate
            aSLL ( i ) (N-1 downto N-i) <= ( others => '0') ;
        end generate right_fill ;
    end generate generateSLL ;

-- The value of shift_amt ( in binary ) determines number of bits A is
--shifted .
-- Since shift_amt ( in decimal ) must not exceed n -1 so only M bits are
--used . The default or N =4 ,
-- will require 2 shift bits ( M =2) , because 2^2 = 4 , the maximum shift
--.
-- In all cases , 2^ M = N .
    Y <= aSLL ( to_integer ( unsigned ( SHIFT_AMT ) ) ) ;
end Behavioral;
