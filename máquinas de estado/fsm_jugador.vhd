library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.RACETRACK_PKG.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Declaración entradas y salidas la máquina de estados del jugador
entity fsm_jugador is
  Port (
        clk : in std_logic;
        rst : in std_logic;
        vel : in std_logic;
        play : in std_logic;
        pulsos: in std_logic_vector(3 downto 0);
        jug_pista : out std_logic;
        col_jugador : out unsigned(4 downto 0);
        fila_jugador : out unsigned(4 downto 0);
        estado : out unsigned(3 downto 0)
         );
end fsm_jugador;
   
architecture Behavioral of fsm_jugador is
       
        type estados is (inicio, espera, derecha, izquierda, abajo, arriba, derecha_arriba, derecha_abajo, izquierda_arriba, izquierda_abajo);
        signal e_act, e_sig : estados;
        signal col_inicial : unsigned (4 downto 0) := "01101";
        signal fila_inicial : unsigned (4 downto 0) := "11001";
        signal col_jugador_sig : unsigned (4 downto 0);
        signal fila_jugador_sig : unsigned (4 downto 0);
        signal sig_fila, sig_col, ant_fila, ant_col : unsigned (4 downto 0);
        signal jug_en_pista : std_logic;  
          
begin    
P_fsm_seq: process (rst, clk) -- Proceso para poner el etado inicial y actualizarlo cada flanco de reloj
        begin
            if rst ='1' then
                e_act <= inicio;
            elsif clk'event and clk='1' then
                if vel = '1' then
                    e_act <= e_sig;
                end if;                                    
            end if;
end process;
    
P_fsm_comb: process (clk, pulsos) -- Proceso para actualizar los estados segun las pulsaciones de los botones
        begin
            e_sig <= e_act;
        case e_act is
            when inicio =>
                if play = '1' then
                    e_sig <= espera;                                  
                end if;        
            when others =>
                if pulsos = "1001" then
                    e_sig <= derecha_arriba;
                elsif pulsos = "1100" then
                    e_sig <= derecha_abajo;
                elsif pulsos = "0011" then
                    e_sig <= izquierda_arriba;
                elsif pulsos = "0110" then
                    e_sig <= izquierda_abajo;
                elsif pulsos = "1000" then
                    e_sig <= derecha;
                elsif pulsos = "0010" then
                    e_sig <= izquierda;
                elsif pulsos = "0001" then
                    e_sig <= arriba;
                elsif pulsos = "0100" then
                    e_sig <= abajo;
                elsif pulsos = "0000" then
                    e_sig <= espera;                    
                end if;                                                                                                                                                    
        end case;
end process;

p_pos: process(rst, clk)
        begin
            if rst = '1' then -- Para volver a la posición inicial al darle al reset
                col_jugador_sig <= col_inicial;
                fila_jugador_sig <= fila_inicial;
            elsif clk'event and clk = '1' then
            jug_en_pista <= pista(to_integer(fila_jugador_sig))(to_integer(col_jugador_sig)); -- Detecta si el jugador esta fuera de la pista
                if vel = '1' then
                    case e_sig is
                        when derecha => -- Se aumenta una columna
                            col_jugador_sig <= col_jugador_sig + 1;
                            estado <= "0000";                                                      
                        when derecha_arriba => -- Se aumenta una columna y se disminuye una fila
                            col_jugador_sig <= col_jugador_sig + 1;
                            fila_jugador_sig <= fila_jugador_sig - 1;
                            estado <= "0001";                   
                        when derecha_abajo =>  -- Se aumenta una columna y una fila                  
                            col_jugador_sig <= col_jugador_sig + 1;
                            fila_jugador_sig <= fila_jugador_sig + 1;
                            estado <= "0010";                                                                                                           
                        when abajo => -- Se aumenta una fila                         
                            fila_jugador_sig <= fila_jugador_sig + 1;
                            estado <= "0011";                                                                            
                        when izquierda => -- Se disminuye una columna                       
                            col_jugador_sig <= col_jugador_sig - 1;
                            estado <= "0100";                                                                               
                        when izquierda_arriba => -- Se disminuye una columna y una fila
                            col_jugador_sig <= col_jugador_sig - 1;
                            fila_jugador_sig <= fila_jugador_sig - 1;
                            estado <= "0101";                                                                              
                        when izquierda_abajo => -- Se disminuye una columna y se aumenta una fila
                            col_jugador_sig <= col_jugador_sig - 1;
                            fila_jugador_sig <= fila_jugador_sig + 1;
                            estado <= "0110";                                                                                                                                      
                        when arriba => -- Se disminuye una fila                           
                            fila_jugador_sig <= fila_jugador_sig - 1;
                            estado <= "0111";
                        when inicio => -- Posición inicial                           
                            col_jugador_sig <= col_inicial;
                            fila_jugador_sig <= fila_inicial;
                            estado <= "1000";
                        when espera => -- Se mantiene en la misma posicion esperando cambio de estado
                            col_jugador_sig <= col_jugador_sig;
                            fila_jugador_sig <= fila_jugador_sig;
                            estado <= "1001";                                                       
                    end case;
                end if;        
            end if;                                                                                                                                                
end process;                             
    col_jugador <= col_jugador_sig;    
    fila_jugador <= fila_jugador_sig;
    jug_pista <= jug_en_pista;    
end Behavioral;


