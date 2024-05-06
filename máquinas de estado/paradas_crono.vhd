----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2024 17:57:16
-- Design Name: 
-- Module Name: paradas_crono - Behavioral
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

-- Declaración entradas y salidas
entity paradas_crono is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        col_coche : in unsigned(4 downto 0);
        fila_coche : in unsigned(4 downto 0);
        col_fantasma : in unsigned(4 downto 0);
        fila_fantasma : in unsigned(4 downto 0);        
        stop_crono : out STD_LOGIC;
        coche_primero : out std_logic);
end paradas_crono;

architecture Behavioral of paradas_crono is

   -- Componente para detener el crono dependiendo del personaje
    component parada_crono is
        Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        col : in unsigned(4 downto 0);
        fila : in unsigned(4 downto 0);
        parada_crono : out STD_LOGIC);
    end component;
    
    signal stop_crono_coche, stop_crono_fantasma : std_logic;
begin

   -- Se para el crono con el coche 
    crono_stop_coche : parada_crono 
        Port map(
            clk => clk,
            rst => rst,
            col => col_coche,
            fila => fila_coche,
            parada_crono => stop_crono_coche);
            
   -- Se para el crono con el fantasma 
    crono_stop_fantasma : parada_crono 
        Port map(
            clk => clk,
            rst => rst,
            col => col_fantasma,
            fila => fila_fantasma,
            parada_crono => stop_crono_fantasma);

stop_crono <= stop_crono_coche or stop_crono_fantasma or rst; -- El crono se para por el coche, por el fantasma o por el reset
coche_primero <= stop_crono_coche;

end Behavioral;
