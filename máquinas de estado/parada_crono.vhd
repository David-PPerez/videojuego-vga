library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
-- Declaración de entradas y salidas 
entity parada_crono is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        col : in unsigned(4 downto 0);
        fila : in unsigned(4 downto 0);
        parada_crono : out STD_LOGIC);
end parada_crono;
 
architecture Behavioral of parada_crono is

    type state is (st0, st1, st2, st3);
    signal present_state, next_state : state;
    constant salida_fila_abajo : unsigned (4 downto 0) := "11100";--28
    constant salida_fila_arriba : unsigned (4 downto 0) := "10111";--23

begin 
Proceso_sinc: process (clk) -- para poner el estado 0 con el reset o si no que continue al siguiente
begin
    if rising_edge(clk) then
        if (rst = '1') then
            present_state <= st0;
        else
            present_state <= next_state;
        end if;
    end if;
end process;
 
output_decoder : process(present_state, col, fila, clk) -- Proceso para variar estados segun nos acercamos a la linea de meta y se pare el crono 
                                                        -- al llegar al estado requerido
begin   
    case (present_state) is
        when st0 =>
            if col = "01100" then -- columna 12 y fila mayor que 23, pero menor que 28
                next_state <= st1;
            else
                next_state <= st0; 
            end if;
        when st1 =>
            if col = "01101" then -- columna 13 y fila mayor que 23, pero menor que 28
                next_state <= st2;
            elsif col = "01100" then -- Para mantenerte en ese estado en esa columna
                next_state <= st1;
            else
                next_state <= st0;                   
            end if; 
        when st2 =>
            if col = "01110" then -- columna 14 y fila mayor que 23, pero menor que 28
                next_state <= st3;
            elsif col = "01101" then -- Para mantenerte en ese estado en esa columna
                next_state <= st2;
            elsif col = "01100" then -- Para regresar al anterior estado
                next_state <= st1;
            else
                next_state <= st0;                                          
            end if; 
        when st3 =>
            if col = "01111" then -- Para regresar al estado inicial al llegar a meta
                next_state <= st0;
            end if;
    end case;
 end process;

next_state_decoder : process(present_state) 
begin 
    case (present_state) is -- Cuando el estado sea el 3 se para el crono.
        when st0 => parada_crono <= '0';
        when st1 => parada_crono <= '0';
        when st2 => parada_crono <= '0';
        when st3 => parada_crono <= '1';
        when others => parada_crono <= '0';
    end case;
end process;
 
end Behavioral;
