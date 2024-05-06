----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.04.2024 11:51:32
-- Design Name: 
-- Module Name: fsm_bordeo - Behavioral
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
use WORK.RACETRACK_PKG.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Declaración entradas y salidas de la máquina de estados del fantasma
entity fsm_bordeo is
  Port (
        clk : in std_logic;
        rst : in std_logic;
        vel : in std_logic;
        play: in std_logic;
        col_bordeo : out unsigned(4 downto 0);
        fila_bordeo : out unsigned(4 downto 0)
         );
end fsm_bordeo;
   
architecture Behavioral of fsm_bordeo is
        type estados is (derecha, izquierda, abajo, arriba, inicio);
        signal e_act, e_sig : estados;
        signal col_inicial : unsigned (4 downto 0) := "01101";
        signal fila_inicial : unsigned (4 downto 0) := "11011";
        signal col_bordeo_sig : unsigned (4 downto 0);
        signal fila_bordeo_sig : unsigned (4 downto 0);
        signal pista_derecha, pista_izquierda, pista_abajo, pista_arriba : std_logic;
        signal sig_fila, sig_col, ant_fila, ant_col : unsigned (4 downto 0);        
begin

    sig_fila <= fila_bordeo_sig + 1;
    sig_col <= col_bordeo_sig + 1;
    ant_fila <= fila_bordeo_sig - 1;
    ant_col <= col_bordeo_sig - 1;
   
    process(clk)
        begin
            if ant_fila >= 0 and sig_fila < 30 then
                if ant_col >= 0 and sig_col < 32 then 
                    pista_arriba <= pista(TO_INTEGER(ant_fila))(TO_INTEGER(col_bordeo_sig));
                    pista_abajo <= pista(TO_INTEGER (sig_fila))(TO_INTEGER(col_bordeo_sig));
                    pista_derecha <= pista(TO_INTEGER (fila_bordeo_sig))(TO_INTEGER(sig_col));
                    pista_izquierda <= pista(TO_INTEGER (fila_bordeo_sig))(TO_INTEGER(ant_col));
                end if;  
            else
                pista_arriba <= '1';
                pista_abajo <= '1';
                pista_derecha <= '1';
                pista_izquierda <= '1';
            end if;
    end process;
           
P_fsm_seq: process (rst, clk) -- Proceso para el reiniciar o actualizar el estado cada flanco de reloj
        begin
            if rst ='1' then
                e_act <= inicio;
            elsif clk'event and clk='1' then
                if vel = '1' then
                    e_act <= e_sig;
                end if;                                    
            end if;
end process;
    
P_fsm_comb: process (clk, e_act) -- Proceso que cambiará de estado en función del borde de la pista
        begin
            e_sig <= e_act;
        case e_act is
            when inicio =>
                if play = '1' then -- Se mueve cuando el jugador le da al play
                    e_sig <= derecha;                                  
                end if;        
            when derecha => 
                if pista_derecha = '0' and pista_abajo = '0' then -- Borde en la derecha y abajo
                    e_sig <= arriba;
                elsif pista_abajo = '1' then -- Cuando no hay borde abajo, va en esa dirección
                    e_sig <= abajo;                                     
                end if;
            when arriba =>
                if pista_derecha = '0' and pista_arriba = '0' then -- Borde en la derecha y arriba
                    e_sig <= izquierda;
                elsif pista_derecha = '1' then -- Cuando no hay borde en la derecha, va en esa dirección
                    e_sig <= derecha;                                        
                end if;                    
            when izquierda =>
                if pista_izquierda = '0' then -- Borde en la izquierda
                    e_sig <= abajo;
                elsif pista_arriba = '1' then -- Cuando no hay borde arriba, va en esa dirección
                    e_sig <= arriba;                                        
                end if;                                                                                                                                                     
            when abajo =>
                if pista_derecha = '1' and pista_abajo = '0' then -- Borde abajo, pero no en la derecha
                    e_sig <= derecha;
                elsif pista_izquierda = '1' then -- Cuando no hay borde abajo, va en esa dirección
                    e_sig <= izquierda;                                       
                end if;              
        end case;
end process;
p_pos_aut: process(rst, clk) 
        begin
            if rst = '1' then -- Vuelve a la posición inicial
                col_bordeo_sig <= col_inicial;
                fila_bordeo_sig <= fila_inicial;
            elsif clk'event and clk = '1' then
                if vel = '1' then
                    case e_sig is
                        when derecha =>
                            col_bordeo_sig <= col_bordeo_sig + 1; -- Suma columnas
                        when abajo =>                            
                            fila_bordeo_sig <= fila_bordeo_sig + 1; -- Suma filas
                        when izquierda =>                            
                            col_bordeo_sig <= col_bordeo_sig - 1; -- Resta columnas
                        when arriba =>                            
                            fila_bordeo_sig <= fila_bordeo_sig - 1; -- Resta filas
                        when inicio =>                            
                            col_bordeo_sig <= col_inicial;
                            fila_bordeo_sig <= fila_inicial;                           
                    end case;
                end if;
            end if;                                                                                                                                                
end process;                             
    col_bordeo <= col_bordeo_sig;    
    fila_bordeo <= fila_bordeo_sig;    
end Behavioral;
