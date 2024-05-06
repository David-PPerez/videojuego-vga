----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2024 12:08:44
-- Design Name: 
-- Module Name: mux_2 - Behavioral
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
entity mux_2 is
    Port ( selector : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (1 downto 0);
           Y : out STD_LOGIC);
end mux_2;

architecture Behavioral of mux_2 is 

begin
    process(data,selector) -- Dependiendo de la posición del selector, la salida será igual a una entrada o a otra.
        begin
            if selector = '0' then
                Y <= data(0);
            else Y <= data(1);
            end if;                
    end process;

end Behavioral;
