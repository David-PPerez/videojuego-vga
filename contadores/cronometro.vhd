----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2024 18:45:13
-- Design Name: 
-- Module Name: cronometro - Behavioral
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
-- Declaración de variables de entradas y salidas del cronómetro
entity cronometro is
  Port (
    clk : in std_logic;
    rst : in std_logic;
    enable : in std_logic;
    cuenta_seg : out unsigned(3 downto 0);
    cuenta_dec_seg : out unsigned(2 downto 0);
    cuenta_min : out unsigned(3 downto 0)
   );
end cronometro;

architecture Behavioral of cronometro is

   -- Contador genérico que se usará para los distintos contadores, variando los valores de fin_cuenta y bits_cuenta.
    component contador_generico is
    Generic( fin_cuenta : integer :=10000000;
             bits_cuenta : integer := 24);           
    
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           pulso : out STD_LOGIC;
           cuenta : out unsigned(bits_cuenta - 1 downto 0));
    end component;
   
   -- Declaración de señales
    signal pulso_dec, pulso_seg, pulso_dec_seg, pulso_min : std_logic;
    signal enable_seg, enable_dec_seg, enable_min : std_logic;
    
begin
   -- Contadores para las déciomas de segundo, los segundos, las decenas de segundo y los minutos
    decimas: contador_generico
        generic map(100000000,27)
        port map(
            clk => clk,
            rst => rst,
            enable => enable,
            pulso => pulso_dec);
            
            enable_seg <= enable and pulso_dec;
    
    segundos: contador_generico
        generic map(10,4)
        port map(
            clk => clk,
            rst => rst,
            enable => enable_seg,
            pulso => pulso_seg,
            cuenta => cuenta_seg);
           
            enable_dec_seg <= enable_seg and pulso_seg;
            
    decenas_segundos: contador_generico
        generic map(6,3)        
        port map(
            clk => clk,
            rst => rst,
            enable => enable_dec_seg,
            pulso => pulso_dec_seg,
            cuenta => cuenta_dec_seg);
            
            enable_min <= enable_dec_seg and pulso_dec_seg;
            
    minutos: contador_generico
        generic map(10,4)        
        port map(
            clk => clk,
            rst => rst,
            enable => enable_min,
            cuenta => cuenta_min);
      
end Behavioral;
