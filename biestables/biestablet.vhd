----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2024 17:58:40
-- Design Name: 
-- Module Name: biestablet - Behavioral
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

-- Esta es la implementación de un biestable tipo t

entity biestablet is
    Port ( t : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           q : out STD_LOGIC);
end biestablet;

architecture Behavioral of biestablet is
--La señal que creamos es la misma que la salida, la necesitamos para poder leer el valor de esta variable
 signal qs : std_logic;
 
    begin
        p_biest_t: process (rst, clk)
            begin
                if rst = '1' then --Si el reset está a '0',
                --la señal de salida del biestables tipo t estará a '0'
                qs <= '0';
                elsif clk'event and clk='1' then -- Si estamos en un flanco de reloj de subida
                    if t = '1' then -- y la entrada al biestable está a '1'
                    -- la señal de salida del biestable pasará a ser la que estaba antes de entrar al process, pero de manera negada
                    qs <= not qs;
                    end if;
                end if;
            end process;
-- Se asigna la señal de salida a la salida del biestable tipo t            
q <= qs;
end Behavioral;
