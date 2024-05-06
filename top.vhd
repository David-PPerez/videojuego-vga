----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2024 17:32:47
-- Design Name: 
-- Module Name: top - Behavioral
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
use WORK.RACETRACK_PKG.ALL;
library WORK;
use WORK.VGA_PKG.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           play : in std_logic;
           btnR, btnL, btnU, btnD : in std_logic;           
           rojo : out std_logic_vector(3 downto 0);
           verde : out std_logic_vector(3 downto 0);
           azul : out std_logic_vector(3 downto 0);
           hsinc : out std_logic;
           vsinc : out std_logic);
end top;

architecture Behavioral of top is

-- Componente syncro vga
    component syncro_vga is
        Port (clk : in std_logic;
        rst : in std_logic;
        hsinc : out std_logic;
        visible : out std_logic;
        vsinc : out std_logic;
        fila : out unsigned(9 downto 0);
        col : out unsigned(9 downto 0)
           );
    end component;
    
-- Componente contador, válido para cualquier cuenta    
    component contador_generico is
    Generic( fin_cuenta : integer :=10000000;
             bits_cuenta : integer := 24);           
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           pulso : out STD_LOGIC;
           cuenta : out unsigned(bits_cuenta - 1 downto 0));
    end component;
    
-- Memorias de imágenes, números y letras     
    component ROM1b_1f_red_num32_play_sprite16x16 is
        port (
        clk  : in  std_logic;   -- reloj
        addr : in  std_logic_vector(9-1 downto 0);
	    bit_selector : in  std_logic_vector(3 downto 0);
	    dato_memo: out std_logic);
    end component;

    component ROM1b_1f_green_num32_play_sprite16x16 is
        port (
        clk  : in  std_logic;   -- reloj
        addr : in  std_logic_vector(9-1 downto 0);
	    bit_selector : in  std_logic_vector(3 downto 0);
	    dato_memo: out std_logic);
    end component;

    component ROM1b_1f_blue_num32_play_sprite16x16 is
        port (
        clk  : in  std_logic;   -- reloj
        addr : in  std_logic_vector(9-1 downto 0);
	    bit_selector : in  std_logic_vector(3 downto 0);
	    dato_memo: out std_logic);
    end component;
    
-- Componente para saber cómo pintar el fondo
    component fondos is
    port(
        clk : in std_logic;
        fila_comp : in unsigned(4 downto 0);
        col_comp : in unsigned(4 downto 0);
        rojo_fondo, verde_fondo, azul_fondo: out std_logic);
    end component;
    
 -- Multiplexor de dos a uno con entradas y salidas de tres bits (colores coche y fantasma)       
    component mux2 is
    Port ( selector : in STD_LOGIC_vector(2 downto 0);
           data_0 : in STD_LOGIC_VECTOR (2 downto 0);
           data_1 : in STD_LOGIC_VECTOR (2 downto 0);
           Y : out STD_LOGIC_vector(2 downto 0));
    end component;
    
-- Multiplexor de dos a uno con entradas de un único bit 
    component mux_2 is
    Port ( selector : in STD_LOGIC;
           data : in std_logic_vector(1 downto 0);
           Y : out STD_LOGIC);
    end component;
               
-- Multiplexor de cuatro a uno, con entradas y salidas de tres bits, selector de 2
    component mux4 is
    Port (
        selector : in std_logic_vector(1 downto 0);
        dato_00 : in std_logic_vector(2 downto 0);
        dato_01 : in std_logic_vector(2 downto 0);
        dato_10 : in std_logic_vector(2 downto 0);
        dato_11 : in std_logic_vector(2 downto 0);
        color : out std_logic_vector(2 downto 0));
    end component;

-- Componente para saber qué pintar en cada lugar de la pantalla        
    component pinta is
    Port(
        color_in : in std_logic_vector (2 downto 0);
        color_crono : in std_logic_vector (3 downto 0);
        color_win: in std_logic_vector(2 downto 0);
        color_play: in std_logic_vector(3 downto 0);
        coche_primero : in std_logic;
        estado : in unsigned(3 downto 0);     
        visible: in std_logic;
        col: in unsigned(9 downto 0);
        fila: in unsigned(9 downto 0);
        rojo: out std_logic_vector(c_nb_red-1 downto 0);
        verde: out std_logic_vector(c_nb_green-1 downto 0);
        azul: out std_logic_vector(c_nb_blue-1 downto 0)
        );
    end component;

-- Máquina de estados del fantasma, que bordea la pista    
    component fsm_bordeo is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        vel : in std_logic;
        play: in std_logic;
        col_bordeo : out unsigned(4 downto 0);
        fila_bordeo : out unsigned(4 downto 0)
         );
    end component;
 
 -- Comparador para saber qué pintar, entre los personajes y el fondo   
    component comparadores is
    Port (
        columna_sincro : in unsigned(4 downto 0);
        fila_sincro : in unsigned(4 downto 0);
        columna_coche : in unsigned(4 downto 0);
        fila_coche : in unsigned(4 downto 0);    
        columna_fantasma : in unsigned(4 downto 0);
        fila_fantasma : in unsigned(4 downto 0);
        selector : out std_logic_vector(1 downto 0)    
        );
    end component;

-- Componente que traduce las pulsaciones de la placa al movimiento del jugador
    component control_jugador is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        btnR, btnL, btnU, btnD : in std_logic;
        pulsos : out std_logic_vector(3 downto 0));
    end component;

-- Máquina de estado del jugador     
    component fsm_jugador is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        vel : in std_logic;
        play : in std_logic;
        pulsos : in std_logic_vector(3 downto 0);
        jug_pista : out std_logic;
        col_jugador : out unsigned(4 downto 0);
        fila_jugador : out unsigned(4 downto 0);
        estado : out unsigned(3 downto 0)
         );
    end component;
    
-- Componente para decidir entre qué imagen y qué orientación hay que escoger de la memoria    
    component memo_address_selector is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        columna : in unsigned(9 downto 0);
        fila : in unsigned(9 downto 0);
        estado : in unsigned(3 downto 0);
        address : out std_logic_vector (8 downto 0);
        bit_selector : out std_logic_vector (3 downto 0)
        );
    end component;

-- Componente para decidir entre qué número hay que escoger de la memoria     
    component memo_address_selector_num is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        columna : in unsigned(9 downto 0);
        fila : in unsigned(9 downto 0);
        numero : in unsigned(3 downto 0);
        address : out std_logic_vector (8 downto 0)
    );
    end component;

-- Componente de cronómetro    
    component cronometro is
        Port (
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;
        cuenta_seg : out unsigned(3 downto 0);
        cuenta_dec_seg : out unsigned(2 downto 0);
        cuenta_min : out unsigned(3 downto 0)
    );
    end component;

-- Componente que para el cronómetro al cruzar por meta cualquier personaje    
    component paradas_crono is
        Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        col_coche : in unsigned(4 downto 0);
        fila_coche : in unsigned(4 downto 0);
        col_fantasma : in unsigned(4 downto 0);
        fila_fantasma : in unsigned(4 downto 0);        
        stop_crono : out STD_LOGIC;
        coche_primero : out std_logic);
    end component;
 
 -- Componente de dos biestables d y un biestable t          
    component biestables is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           q : out STD_LOGIC);
    end component;
    
  -- Declaración señales del programa                         
    signal visible_s, enable_col, enable_fila, rojo_coche, verde_coche, azul_coche: std_logic;
    signal rojo_fantasma, verde_fantasma, azul_fantasma: std_logic;
    signal rojo_fondo, verde_fondo, azul_fondo, rojo_in, verde_in, azul_in : std_logic;
    signal col_s, fila_s : unsigned(9 downto 0);
    signal fantasma_col, fantasma_fil, coche_col, coche_fila : unsigned(4 downto 0);
    signal col_comp, fila_comp : unsigned(4 downto 0);
    signal col_int, fila_int, pulsos, bit_selector : std_logic_vector(3 downto 0);
    signal memo_rojo_personaje, memo_verde_personaje, memo_azul_personaje : std_logic_vector(16-1 downto 0); 
    signal memo_rojo_fondo, memo_verde_fondo, memo_azul_fondo : std_logic_vector(32-1 downto 0);
    signal fila_selector, col_selector : std_logic_vector(4 downto 0);
    signal address_coche, address_fantasma, address_seg, address_dec_seg, address_min, address_punto : std_logic_vector(8 downto 0);
    signal address_W, address_I, address_N : std_logic_vector(8 downto 0);
    signal address_P, address_L, address_A, address_Y : std_logic_vector(8 downto 0);
    signal posicion_memo_coche : std_logic_vector(4 downto 0) := "11110";
    signal posicion_memo_coche_diagonal : std_logic_vector(4 downto 0) := "11111";
    signal posicion_memo_fantasma : std_logic_vector(4 downto 0) := "11010";
    signal posicion_memo_punto : std_logic_vector(4 downto 0) := "10101";
    signal posicion_memo_P : std_logic_vector(4 downto 0) := "01010";
    signal posicion_memo_L : std_logic_vector(4 downto 0) := "01011";
    signal posicion_memo_A : std_logic_vector(4 downto 0) := "01100";
    signal posicion_memo_Y : std_logic_vector(4 downto 0) := "01101";
    signal posicion_memo_W : std_logic_vector(4 downto 0) := "10001";
    signal posicion_memo_I : std_logic_vector(4 downto 0) := "10010";
    signal posicion_memo_N : std_logic_vector(4 downto 0) := "10011";
    signal color_coche, color_fantasma, color_fondo, color_0, color_1, color_in, color_win : std_logic_vector(2 downto 0); 
    signal color_crono, color_play : std_logic_vector(3 downto 0);
    signal vel_1dec, vel_5dec: std_logic;
    signal uno_logico: std_logic:= '1';
    signal jug_en_pista, vel: std_logic;
    signal selector_color : std_logic_vector(1 downto 0);
    signal color_seg, color_dec_seg, color_min, color_punto, color_W, color_I, color_N, color_P, color_L, color_A, color_Y: std_logic;
    signal estado_jugador, cuenta_seg, cuenta_dec_seg, cuenta_min : unsigned(3 downto 0);
    signal cuenta_dec_seg_x : unsigned(2 downto 0);
    signal coche_primero, pulso_coche_primero, pulso_play, rst_crono: std_logic;
begin

 
    col_comp <= col_s(8 downto 4);
    fila_comp <= fila_s(8 downto 4);
    
    fila_int <= std_logic_vector(fila_s(3 downto 0));
    col_int <= std_logic_vector(col_s(3 downto 0));
    
   -- Sincro VGA 
    sincro_vga : syncro_vga
        port map(
            clk => clk,
            rst => rst,
            hsinc => hsinc,
            visible => visible_s,
            vsinc => vsinc,
            fila => fila_s,
            col => col_s);    
            
   -- Contadores para la velocidad si estas en la pista o fuera de ella
    velocidad_1dec: contador_generico
        generic map(10000000, 24)
        port map(
            clk => clk,
            rst => rst,
            enable => uno_logico,
            pulso => vel_1dec);

    velocidad_5dec: contador_generico
        generic map(50000000, 26)
        port map(
            clk => clk,
            rst => rst,
            enable => uno_logico,
            pulso => vel_5dec);
            
   -- Multiplexor para elegir a que velocidad se mueve el jugador
    selector_velocidad : mux_2
        port map(
            selector => jug_en_pista,
            data (0) => vel_5dec,
            data (1) => vel_1dec,
            Y => vel);
            
   -- Para comparar el fondo, el jugador y el fantasma         
    comparators : comparadores
        Port map(
        columna_sincro => col_comp,
        fila_sincro => fila_comp,
        columna_coche => coche_col,
        fila_coche => coche_fila,    
        columna_fantasma => fantasma_col,
        fila_fantasma => fantasma_fil,
        selector => selector_color    
        );
        
   -- Selección para escoger el número de la memoria
    address_bit_selector : memo_address_selector
        Port map (
            clk => clk,
            rst => rst,
            columna => col_s,
            fila => fila_s,
            estado => estado_jugador,
            address => address_coche,
            bit_selector => bit_selector);
            
   -- Llaman a las memorias del coche y del fantasma              
    coche_rojo: ROM1b_1f_red_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_coche,
            bit_selector => bit_selector,
            dato_memo => rojo_coche); 

    coche_verde: ROM1b_1f_green_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_coche,
            bit_selector => bit_selector,
            dato_memo => verde_coche);
            
    coche_azul: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_coche,
            bit_selector => bit_selector,
            dato_memo => azul_coche);
            
                                 
    color_coche <= rojo_coche & verde_coche & azul_coche;
    
    address_fantasma <= posicion_memo_fantasma & fila_int;
    
    fantasma_rojo: ROM1b_1f_red_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_fantasma,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => rojo_fantasma); 

    fantasma_verde: ROM1b_1f_green_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_fantasma,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => verde_fantasma);
            
    fantasma_azul: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_fantasma,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => azul_fantasma); 
                                
   
    color_fantasma <= rojo_fantasma & verde_fantasma & azul_fantasma; 
           
   -- Fondo de la pista con los colores 
    pista: fondos
        port map(
            clk => clk,
            col_comp => col_comp,
            fila_comp => fila_comp,
            rojo_fondo => rojo_fondo,
            verde_fondo => verde_fondo,
            azul_fondo => azul_fondo);
    color_fondo <= rojo_fondo & verde_fondo & azul_fondo; 
    
   -- Cronómetro para contar el tiempo de la vuelta del juador o del fantasma
    crono: cronometro 
        Port map (
            clk => clk,
            rst => rst,
            enable => pulso_play,
            cuenta_seg => cuenta_seg,
            cuenta_dec_seg => cuenta_dec_seg_x,
            cuenta_min => cuenta_min);
    
    cuenta_dec_seg <= '0' & cuenta_dec_seg_x;
    
   -- Llaman a las memorias de los números para los segundos, las decenas de segundo y los minutos             
    segundos: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_seg,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_seg);                  

    dec_segundos: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_dec_seg,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_dec_seg);
    
    address_punto <= posicion_memo_punto & fila_int;        
    punto: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_punto,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_punto);            
            
    minutos: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_min,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_min);
            
    
    color_crono <= color_punto & color_min & color_dec_seg & color_seg;
    
   

    
   -- Llama a las letras P,L,A e Y para escribir la palabra PLAY
    address_P <= posicion_memo_P & fila_int;   
    P: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_P,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_P);
            
    address_L <= posicion_memo_L & fila_int;
    L: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_L,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_L);

    address_A <= posicion_memo_A & fila_int;
    A: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_A,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_A); 
            
    address_Y <= posicion_memo_Y & fila_int;
    Y: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_Y,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_Y);         
            
           
    color_play <= color_P & color_L & color_A & color_Y; 
   
   -- Llama a las letras W,I y N para escribir la palabra WIN
                
    address_W <= posicion_memo_W & fila_int;
    W: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_W,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_W);
            
    address_I <= posicion_memo_I & fila_int;
    
    I: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_I,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_I);

    address_N <= posicion_memo_N & fila_int;
    N: ROM1b_1f_blue_num32_play_sprite16x16
        port map (
            clk  => clk,
            addr => address_N,
            bit_selector => std_logic_vector(col_s(3 downto 0)),
            dato_memo => color_N); 
            
           
    color_win <= color_W & color_I & color_N; 
            
   -- Elige entre el coche y el fondo                                                                
    mux_coche: mux2
        port map(
            selector => color_coche,
            data_0 => color_fondo,
            data_1 => color_coche,
            Y => color_1);
            
   -- Elige entre el fantasma y el fondo          
    mux_fantasma: mux2
        port map(
            selector => color_fantasma,
            data_0 => color_fondo,
            data_1 => color_fantasma,
            Y => color_0);
            
   -- Elige el color         
    mux_color: mux4
        Port map (
            selector => selector_color,
            dato_00 => color_fondo,
            dato_01 => color_0,
            dato_10 => color_1,
            dato_11 => color_1,
            color => color_in);  
            
   -- Pinta lo elegido en la pantalla (cronometro, palabra win etc)         
    pinta2: pinta
        port map(
            color_in => color_in,
            color_crono => color_crono,
            color_win => color_win,
            color_play => color_play,
            coche_primero => pulso_coche_primero,            
            estado => estado_jugador,            
            visible => visible_s,
            col => col_s,
            fila => fila_s,
            rojo => rojo, 
            verde => verde,
            azul => azul);
            
   -- Selecciona la memoria de cada número para los segundos, las decenas de segundo y los minutos
    address_selector_seg:  memo_address_selector_num
        Port map(
            clk => clk,
            rst => rst,
            columna =>col_s,
            fila => fila_s,
            numero => cuenta_seg,
            address => address_seg);

    address_selector_dec_seg:  memo_address_selector_num
        Port map(
            clk => clk,
            rst => rst,
            columna => col_s,
            fila => fila_s,
            numero => cuenta_dec_seg,
            address => address_dec_seg);

    address_selector_min:  memo_address_selector_num
        Port map(
            clk => clk,
            rst => rst,
            columna => col_s,
            fila => fila_s,
            numero => cuenta_min,
            address => address_min);
            
   --  Paradas del crono según las llegadas a meta del coche o del fantasma, si ocurre un reset o si el coche llega primero       
    crono_stop : paradas_crono 
        Port map(
            clk => clk,
            rst => rst,
            col_coche => coche_col,
            fila_coche => coche_fila,
            col_fantasma => fantasma_col,
            fila_fantasma => fantasma_fil,            
            stop_crono => rst_crono,
            coche_primero => coche_primero);
     
   -- Biestable para obtener un pulso y saber que el coche ha llegado primero y poner el WIN         
    coche_primero_pulso : biestables
        port map(
            btn => coche_primero,
            clk => clk,
            rst => rst,
            q => pulso_coche_primero);
            
   -- Boton para el inicio del juego         
    play_pulso: biestables
        port map(
            btn => play,
            clk => clk,
            rst => rst_crono,
            q => pulso_play);
            
   -- Botones para controlar el coche en las distintas direcciones                                                    
    control_del_jugador : control_jugador 
        Port map (
            clk => clk,
            rst => rst,
            btnR => btnR,
            btnL => btnl,
            btnU => btnu,
            btnD => btnd,
            pulsos => pulsos);
  
   -- Máquina de estados del jugador
    jugador_fsm: fsm_jugador
        Port map (
            clk => clk,
            rst => rst,
            vel => vel,
            play => pulso_play, 
            pulsos => pulsos,
            jug_pista => jug_en_pista,
            col_jugador => coche_col,
            fila_jugador => coche_fila,
            estado => estado_jugador
            );
            
   -- Máquina de estados del fantasma
    bordeo_fsm: fsm_bordeo
        port map(
            clk => clk,
            rst => rst,
            vel => vel_1dec,
            play => pulso_play,
            col_bordeo => fantasma_col,
            fila_bordeo => fantasma_fil);        
                                                                                                                                 
end Behavioral;
