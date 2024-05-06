----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2024 11:03:21
-- Design Name: 
-- Module Name: mux2 - Behavioral
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
entity mux2 is
    Port ( selector : in STD_LOGIC_vector(2 downto 0);
           data_0 : in STD_LOGIC_VECTOR (2 downto 0);
           data_1 : in STD_LOGIC_VECTOR (2 downto 0);
           Y : out STD_LOGIC_vector(2 downto 0));
end mux2;

architecture Behavioral of mux2 is

begin
    process(data_0, data_1,selector) -- Dependiendo de la posición del selector, la salida será igual a una entrada o a otra.
        begin
            if selector = "111" then
                Y <= data_0;
            else Y <= data_1;
            end if;                
    end process;

end Behavioral;
