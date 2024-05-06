----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2024 16:50:38
-- Design Name: 
-- Module Name: memo_address_selector - Behavioral
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

-- Declaramos las entradas y salidas
entity memo_address_selector is
  Port (
    clk : in std_logic;
    rst : in std_logic;
    columna : in unsigned(9 downto 0);
    fila : in unsigned(9 downto 0);
    estado : in unsigned(3 downto 0);
    address : out std_logic_vector (8 downto 0);
    bit_selector : out std_logic_vector (3 downto 0)
   );
end memo_address_selector;

architecture Behavioral of memo_address_selector is
   
   -- Posiciones de las memorias del coche, del coche en diagonal y del fantasma 
    signal posicion_memo_coche : std_logic_vector(4 downto 0) := "11110";
    signal posicion_memo_coche_diagonal : std_logic_vector(4 downto 0) := "11111";
    signal posicion_memo_fantasma : std_logic_vector(4 downto 0) := "11010";
    
begin

    process(rst, estado) -- Proceso para invertir columnas, filas o ambas, en la memoria del coche, según la dirección en la que vaya el jugador
        begin
            if rst = '1' then
                address <= posicion_memo_coche & not(std_logic_vector(columna(3 downto 0)));
                bit_selector <= std_logic_vector(fila(3 downto 0));
            elsif rising_edge(clk) then
                if estado = "0000" then --derecha
                    address <= posicion_memo_coche & not(std_logic_vector(columna(3 downto 0)));
                    bit_selector <= std_logic_vector(fila(3 downto 0));
                elsif estado = "0001" then -- derecha arriba
                    address <= posicion_memo_coche_diagonal & std_logic_vector(fila(3 downto 0));
                    bit_selector <= std_logic_vector(columna(3 downto 0));
                elsif estado = "0010" then -- derecha abajo
                    address <= posicion_memo_coche_diagonal & not(std_logic_vector(fila(3 downto 0)));
                    bit_selector <= std_logic_vector(columna(3 downto 0));
                elsif estado = "0011" then -- abajo
                    address <= posicion_memo_coche & not(std_logic_vector(fila(3 downto 0)));
                    bit_selector <= std_logic_vector(columna(3 downto 0));
                elsif estado = "0100" then -- izquierda
                    address <= posicion_memo_coche & std_logic_vector(columna(3 downto 0));
                    bit_selector <= not(std_logic_vector(fila(3 downto 0)));
                elsif estado = "0101" then -- izquierda arriba
                    address <= posicion_memo_coche_diagonal & std_logic_vector(fila(3 downto 0));
                    bit_selector <= not(std_logic_vector(columna(3 downto 0)));
                elsif estado = "0110" then -- izquierda abajo
                    address <= posicion_memo_coche_diagonal & not(std_logic_vector(fila(3 downto 0)));
                    bit_selector <= not(std_logic_vector(columna(3 downto 0)));                                    
                elsif estado = "0111" then -- arriba
                    address <= posicion_memo_coche & std_logic_vector(fila(3 downto 0));
                    bit_selector <= std_logic_vector(columna(3 downto 0));
                elsif estado = "1000" then -- inicio
                    address <= posicion_memo_coche & not(std_logic_vector(columna(3 downto 0)));
                    bit_selector <= std_logic_vector(fila(3 downto 0));
                else
                    address <= posicion_memo_coche & not(std_logic_vector(columna(3 downto 0)));
                    bit_selector <= std_logic_vector(fila(3 downto 0));                                
                end if;
            end if;                                                                                                                                                                                                                                                                                                                        
    end process;
end Behavioral;
