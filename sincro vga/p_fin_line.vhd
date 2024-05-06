----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2024 13:58:20
-- Design Name: 
-- Module Name: P_fin_col - Behavioral
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
library WORK;
use WORK.VGA_PKG.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Declaramos las entradas y salidas
entity P_fin_line is
    Port ( cont_line : in unsigned(9 downto 0);
           vsync : out STD_LOGIC;
           visible_line : out STD_LOGIC);
end P_fin_line;

architecture Behavioral of P_fin_line is

begin
    Process(cont_line) -- Proceso para saber si se esta dentro de la zona línea visible o no
        begin
            if cont_line < c_line_visible then -- Aún está en la zona visible
                visible_line <= '1';
            else visible_line <= '0'; -- Fuera de la zona visible
            end if;
            
            if cont_line > c_line_2_synch then -- Indica cuando el sincro vertical es '1' o '0'
                    vsync <= '1';
            elsif cont_line < c_line_2_synch + 1 then
                if cont_line > c_line_2_fporch then
                    vsync <= '0';
                end if;
            else vsync <= '1';                    
            end if;
    end process;
end Behavioral;