----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2024 12:16:32
-- Design Name: 
-- Module Name: mux4 - Behavioral
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
entity mux4 is
  Port (
    selector : in std_logic_vector(1 downto 0);
    dato_00 : in std_logic_vector(2 downto 0);
    dato_01 : in std_logic_vector(2 downto 0);
    dato_10 : in std_logic_vector(2 downto 0);
    dato_11 : in std_logic_vector(2 downto 0);
    color : out std_logic_vector(2 downto 0)
   );
end mux4;

architecture Behavioral of mux4 is

begin
    process(dato_00, dato_01, dato_10, dato_11, selector) -- Dependiendo de la posición del selector, el color será igual a una entrada o a otra.
        begin
            if selector = "00" then
                color <= dato_00;
            elsif selector = "01" then
                color <= dato_01;
            elsif selector = "10" then
                color <= dato_10;
            else color <= dato_11;                                            
            end if;                
    end process;

end Behavioral;
