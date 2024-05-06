----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2024 11:44:48
-- Design Name: 
-- Module Name: comparadores - Behavioral
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

-- Declaración de entradas y salidas del comparador
entity comparadores is
  Port (
    columna_sincro : in unsigned(4 downto 0);
    fila_sincro : in unsigned(4 downto 0);
    columna_coche : in unsigned(4 downto 0);
    fila_coche : in unsigned(4 downto 0);    
    columna_fantasma : in unsigned(4 downto 0);
    fila_fantasma : in unsigned(4 downto 0);
    selector : out std_logic_vector(1 downto 0)    
   );
end comparadores;

architecture Behavioral of comparadores is

   -- Componente comparador, valido para comparar lo que se requiera
    component comparator is
    Port (
        A : in unsigned(4 downto 0);
        B : in unsigned(4 downto 0);
        equal : out std_logic);
    end component;
    
   -- Declaración de señales
    signal equal_col_coche_fondo, equal_fila_coche_fondo, equal_col_fantasma_fondo, equal_fila_fantasma_fondo : std_logic;
    signal equal_coche_fondo, equal_fantasma_fondo : std_logic;
begin

   -- Comparar filas y columnas del coche con el fondo
    comparador_col_coche_fondo: comparator
        port map(
            A => columna_sincro,
            B => columna_coche,
            equal => equal_col_coche_fondo);
            
    comparador_fila_coche_fondo: comparator
        port map(
            A => fila_sincro,
            B => fila_coche,
            equal => equal_fila_coche_fondo);
            
            equal_coche_fondo <= equal_col_coche_fondo and equal_fila_coche_fondo;
            
   -- Comparar filas y columnas del fantasma con el fondo
    comparador_col_fantasma_fondo: comparator
        port map(
            A => columna_sincro,
            B => columna_fantasma,
            equal => equal_col_fantasma_fondo);
            
    comparador_fila_fantasma_fondo: comparator
        port map(
            A => fila_sincro,
            B => fila_fantasma,
            equal => equal_fila_fantasma_fondo);
            
            equal_fantasma_fondo <= equal_col_fantasma_fondo and equal_fila_fantasma_fondo;
                        
	selector <= equal_coche_fondo & equal_fantasma_fondo;                          

end Behavioral;
