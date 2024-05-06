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

-- Declaración entradas y señales
entity memo_address_selector_num is
  Port (
    clk : in std_logic;
    rst : in std_logic;
    columna : in unsigned(9 downto 0);
    fila : in unsigned(9 downto 0);
    numero : in unsigned(3 downto 0);
    address : out std_logic_vector (8 downto 0)
   );
end memo_address_selector_num;

architecture Behavioral of memo_address_selector_num is
    
    -- Memorias desde el número 0 al 9
    signal posicion_memo_0 : std_logic_vector(4 downto 0) := "00000";
    signal posicion_memo_1 : std_logic_vector(4 downto 0) := "00001";
    signal posicion_memo_2 : std_logic_vector(4 downto 0) := "00010";
    signal posicion_memo_3 : std_logic_vector(4 downto 0) := "00011";
    signal posicion_memo_4 : std_logic_vector(4 downto 0) := "00100";
    signal posicion_memo_5 : std_logic_vector(4 downto 0) := "00101";
    signal posicion_memo_6 : std_logic_vector(4 downto 0) := "00110";
    signal posicion_memo_7 : std_logic_vector(4 downto 0) := "00111";
    signal posicion_memo_8 : std_logic_vector(4 downto 0) := "01000";
    signal posicion_memo_9 : std_logic_vector(4 downto 0) := "01001";
    
begin

    process(rst, numero) -- Va actualizando la memoria del número para que varíe en el cronómetro
        begin
            if rst = '1' then
                address <= posicion_memo_0 & std_logic_vector(fila(3 downto 0));
            elsif rising_edge(clk) then
                if numero = "0000" then 
                    address <= posicion_memo_0 & std_logic_vector(fila(3 downto 0));
                elsif numero = "0001" then
                    address <= posicion_memo_1 & std_logic_vector(fila(3 downto 0));
                elsif numero = "0010" then 
                    address <= posicion_memo_2 & std_logic_vector(fila(3 downto 0));
                elsif numero = "0011" then 
                    address <= posicion_memo_3 & std_logic_vector(fila(3 downto 0));
                elsif numero = "0100" then 
                    address <= posicion_memo_4 & std_logic_vector(fila(3 downto 0));
                elsif numero = "0101" then 
                    address <= posicion_memo_5 & std_logic_vector(fila(3 downto 0));
                elsif numero = "0110" then
                    address <= posicion_memo_6 & std_logic_vector(fila(3 downto 0));                                
                elsif numero = "0111" then 
                    address <= posicion_memo_7 & std_logic_vector(fila(3 downto 0));
                elsif numero = "1000" then
                    address <= posicion_memo_8 & std_logic_vector(fila(3 downto 0));
                else
                    address <= posicion_memo_9 & std_logic_vector(fila(3 downto 0));                               
                end if;
            end if;                                                                                                                                                                                                                                                                                                                        
    end process;
end Behavioral;