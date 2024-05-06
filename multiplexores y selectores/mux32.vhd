----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2024 11:40:33
-- Design Name: 
-- Module Name: mux32 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Declaración de las entradas y salidas
entity mux32 is
    Port ( selector : in STD_LOGIC_VECTOR (4 downto 0);
           data : in STD_LOGIC_VECTOR (31 downto 0);
           Y : out STD_LOGIC);
end mux32;

architecture Behavioral of mux32 is

begin
    process(data,selector)
        begin
            case selector is -- Dependiendo del selector, la salida será igual a una entrada o a otra.
                when "00000" => Y <= data(0);
                when "00001" => Y <= data(1);
                when "00010" => Y <= data(2);
                when "00011" => Y <= data(3);
                when "00100" => Y <= data(4);
                when "00101" => Y <= data(5);
                when "00110" => Y <= data(6);
                when "00111" => Y <= data(7);
                when "01000" => Y <= data(8);
                when "01001" => Y <= data(9);
                when "01010" => Y <= data(10);
                when "01011" => Y <= data(11);
                when "01100" => Y <= data(12);
                when "01101" => Y <= data(13);
                when "01110" => Y <= data(14);
                when "01111" => Y <= data(15);
                when "10000" => Y <= data(16);
                when "10001" => Y <= data(17);
                when "10010" => Y <= data(18);
                when "10011" => Y <= data(19);
                when "10100" => Y <= data(20);
                when "10101" => Y <= data(21);
                when "10110" => Y <= data(22);
                when "10111" => Y <= data(23);
                when "11000" => Y <= data(24);
                when "11001" => Y <= data(25);
                when "11010" => Y <= data(26);
                when "11011" => Y <= data(27);
                when "11100" => Y <= data(28);
                when "11101" => Y <= data(29);
                when "11110" => Y <= data(30);
                when others => Y <= data(31);                
            end case;   
    end process;
    
end Behavioral;