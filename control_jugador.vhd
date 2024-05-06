----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2024 16:23:57
-- Design Name: 
-- Module Name: control_jugador - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_jugador is
  Port (
        clk : in std_logic;
        rst : in std_logic;
        btnR, btnL, btnU, btnD : in std_logic;
        pulsos : out std_logic_vector(3 downto 0));
end control_jugador;

architecture Behavioral of control_jugador is
    
begin
            
    def_pulsos: process(rst, clk) -- Control del jugador por los botones
        begin
            if rst = '1' then
                pulsos <= "0000"; -- Ningun botón pulsado
            elsif btnU = '1' and btnR = '1' then
                pulsos <= "1001"; -- Derecha arriba
            elsif btnD = '1' and btnR = '1' then
                pulsos <= "1100"; -- Derecha abajo
            elsif btnU = '1' and btnL = '1' then
                pulsos <= "0011"; -- Izquierda arriba
            elsif btnD = '1' and btnL = '1' then
                pulsos <= "0110"; -- Izquierda abajo                                                               
            elsif btnU = '1' then 
                pulsos(0) <= '1'; -- Arriba
            elsif btnL = '1' then 
                pulsos(1) <= '1'; -- Izquierda
            elsif btnD = '1' then 
                pulsos(2) <= '1'; -- Abajo
            elsif btnR = '1' then 
                pulsos(3) <= '1'; -- Derecha
            else pulsos <= "0000";                
            end if;                                                                                           
        end process;                                               
end Behavioral;
