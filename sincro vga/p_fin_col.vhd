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
entity P_fin_col is
    Port ( cont_pxl : in unsigned(9 downto 0);
           hsynch : out STD_LOGIC;
           visible_pxl : out STD_LOGIC;
           new_line : out STD_LOGIC);
end P_fin_col;

architecture Behavioral of P_fin_col is

begin
    Process(cont_pxl) -- Proceso para saber si se esta dentro de la zona pixel visible o no
        begin
            if cont_pxl < c_pxl_visible then -- Aún está en la zona visible
                visible_pxl <= '1';
            else visible_pxl <= '0'; -- Fuera de la zona visible
            end if;
            
            if cont_pxl > c_pxl_2_synch then -- Indica cuando el sincro horizontal es '1' o '0'
                    hsynch <= '1';
            elsif cont_pxl < c_pxl_2_synch then
                if cont_pxl > c_pxl_2_fporch -1 then
                    hsynch <= '0';
                end if;
            else hsynch <= '1';                    
            end if;
            
            if cont_pxl = c_pxl_total - 1 then -- Comienza otra cuenta de pixel en otra linea
                new_line <= '1';
            else new_line <= '0';                
            end if;
    end process;
end Behavioral;