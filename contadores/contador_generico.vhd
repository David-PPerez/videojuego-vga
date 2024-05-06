----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2024 11:31:44
-- Design Name: 
-- Module Name: P_Conta1decima - Behavioral
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


-- Declaramos las entradas y salidas de nuestro contador. 
entity contador_generico is
    Generic( fin_cuenta : integer :=10000000;
             bits_cuenta : integer := 24);           
    
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           pulso : out STD_LOGIC;
           cuenta : out unsigned(bits_cuenta - 1 downto 0));
end contador_generico;

architecture Behavioral of contador_generico is
-- Señales que tiene el contador.
    signal pulso_s : std_logic;
    signal cuenta_s: unsigned(bits_cuenta - 1 downto 0); -- Para trabajar con numeros binarios.
    signal fin_cuenta_uns: unsigned(bits_cuenta - 1 downto 0);
    
begin

fin_cuenta_uns <= TO_UNSIGNED(fin_cuenta, fin_cuenta_uns'length); -- Para la conversión. 
    Process (rst,clk)
        begin

            if rst = '1' then --Si el reset está a '1',la variable cuenta_s estara a '0'.
                cuenta_s <= (others =>'0');                
            elsif rising_edge(clk)then --Cuando ocurra un flanco de subida.
                if enable = '1' then 
                    if pulso_s = '1' then -- cuenta_s estará a '0'.
                        cuenta_s <= (others =>'0');   
                    elsif pulso_s = '0' then -- cuenta_s va aumentando su valor.
                        cuenta_s <= cuenta_s + 1;
                    end if;           
                end if;  
             end if;
    end process; 
    
    -- Relacionamos las señales con las salidas.
    pulso_s <= '1' when (enable = '1' and cuenta_s = fin_cuenta_uns - 1)  else '0';
    pulso <= pulso_s;
    cuenta <= cuenta_s;           

end Behavioral;
