----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2024 10:51:10
-- Design Name: 
-- Module Name: pinta - Behavioral
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
library WORK;
use WORK.VGA_PKG.ALL; 

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Declaración de las entradas y salidas
entity pinta is
    Port(
        color_in : in std_logic_vector (2 downto 0);
        color_crono : in std_logic_vector (3 downto 0);
        color_win: in std_logic_vector(2 downto 0);
        color_play: in std_logic_vector(3 downto 0);
        coche_primero: in std_logic;
        estado : in unsigned(3 downto 0);
        visible: in std_logic;
        col: in unsigned(9 downto 0);
        fila: in unsigned(9 downto 0);
        rojo: out std_logic_vector(c_nb_red-1 downto 0);
        verde: out std_logic_vector(c_nb_green-1 downto 0);
        azul: out std_logic_vector(c_nb_blue-1 downto 0)
        );
end pinta;

architecture Behavioral of pinta is

begin

  P_pinta: Process (visible, col, fila) -- Proceso para pintar las letras, el crono etc.
    begin
        if visible = '1' then -- Zona visible del syncro
            if col > 511 then 
                if fila >= 15 and fila < 31 then -- Filas donde va a ir el crono
                    if col < 527 then -- Minutos
                        rojo <= (others => color_crono(2));     
                        verde <= (others => color_crono(2));     
                        azul <= (others => color_crono(2));
                    elsif col > 527 and col < 543 then -- Dos puntos
                        rojo <= (others => color_crono(3));     
                        verde <= (others => color_crono(3));     
                        azul <= (others => color_crono(3));
                    elsif col > 543 and col < 559 then -- Decenas de segundo
                        rojo <= (others => color_crono(1));     
                        verde <= (others => color_crono(1));     
                        azul <= (others => color_crono(1));
                    elsif col > 559 and col < 575 then -- Segundos
                        rojo <= (others => color_crono(0));     
                        verde <= (others => color_crono(0));     
                        azul <= (others => color_crono(0));                        
                    else                                 
                        rojo <= "1110";     
                        verde <= "1110";     
                        azul <= "1110";
                    end if;
                    
                elsif fila >= 95 and fila < 111 then -- Filas donde aparecera el win
                    if coche_primero = '1' then -- Aparece si el primero en llegar es el coche
                        if col < 527 then -- W
                            rojo <= (others => color_win(2));     
                            verde <= (others => color_win(2));     
                            azul <= (others => color_win(2));
                        elsif col > 527 and col < 543 then --I
                            rojo <= (others => color_win(1));     
                            verde <= (others => color_win(1));     
                            azul <= (others => color_win(1));
                        elsif col > 543 and col < 559 then --N
                            rojo <= (others => color_win(0));     
                            verde <= (others => color_win(0));     
                            azul <= (others => color_win(0));                        
                        else                                 
                            rojo <= "1110";     
                            verde <= "1110";     
                            azul <= "1110";
                        end if;
                     else
                        rojo <= "1110";     
                        verde <= "1110";     
                        azul <= "1110";                                                                    
                     end if;   
                elsif fila >= 143 and fila < 159 then -- Filas donde aparecera play
                    if estado = "1000" then
                        if col < 527 then -- P
                            rojo <= (others => color_play(3));     
                            verde <= (others => color_play(3));     
                            azul <= (others => color_play(3));
                        elsif col > 527 and col < 543 then --L
                            rojo <= (others => color_play(2));     
                            verde <= (others => color_play(2));     
                            azul <= (others => color_play(2));
                        elsif col > 543 and col < 559 then --A
                            rojo <= (others => color_play(1));     
                            verde <= (others => color_play(1));     
                            azul <= (others => color_play(1));
                        elsif col > 559 and col < 575 then --Y
                            rojo <= (others => color_play(0));     
                            verde <= (others => color_play(0));     
                            azul <= (others => color_play(0));                              
                        else                                 
                            rojo <= "1110";     
                            verde <= "1110";     
                            azul <= "1110";
                        end if;
                     else
                        rojo <= "1110";     
                        verde <= "1110";     
                        azul <= "1110";                                                                    
                     end if;     
                  else                                 
                            rojo <= "1110";     
                            verde <= "1110";     
                            azul <= "1110";                                                                                                                                         
              end if;
                                    
            else -- Segun la entrada, el color es uno u otro
                if color_in(2) = '1' then
                    rojo <= (others => '1');
                else rojo <= (others => '0');
                end if;                                     
                if color_in(1) = '1' then
                    verde <= (others => '1');
                else verde <= (others => '0');
                end if;                                   
                if color_in(0) = '1' then
                    azul <= (others => '1');
                else azul <= (others => '0');
                end if;
            end if;
        else
                rojo <= "0000";     
                verde <= "0000";     
                azul <= "0000";             
        end if;
    end process;                                      
end Behavioral;
