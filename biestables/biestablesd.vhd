----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2024 16:10:07
-- Design Name: 
-- Module Name: biestablesd - Behavioral
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

-- Esta es la implementación de dos biestables tipo d en cascada

entity biestablesd is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulso : out STD_LOGIC);
end biestablesd;

architecture Behavioral of biestablesd is
--Las señales intermedias son las dos salidas de cada uno de los biestables tipo d
    signal q1: std_logic;
    signal q2: std_logic;

    begin
        detector_flanco: process (rst, clk)
            begin
                if rst = '1' then --Si el reset está a '0',
                    --las dos salidas de los biestables tipo d estarán a '0'
                    q1 <= '0'; 
                    q2 <= '0';
                elsif clk'event and clk='1' then -- Si estamos en un flanco de reloj de subida
                    --el valor de la salida del primer biestable será la entrada del botón y la del segundo biestable será la que
                    --estaba antes de entrar a ese process en q1
                    q1 <= btn;
                    q2 <= q1;
                    --La salida de la implementación de los dos biestables en cascada será '1' cuando la salida del primer biestable
                    --esté a '1' y la del segundo a '0', por eso implementaremos una and con la salida q2 negada
                    pulso <= q1 and not(q2);
                end if;
        end process;
       
end Behavioral;
