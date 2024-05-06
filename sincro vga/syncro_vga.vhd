----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2024 13:34:00
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
library WORK;
use WORK.VGA_PKG.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Declaramos las entradas y salidas del syncro vga
entity syncro_vga is
  Port (clk : in std_logic;
        rst : in std_logic;
        hsinc : out std_logic;
        visible : out std_logic;
        vsinc : out std_logic;
        fila : out unsigned(9 downto 0);
        col : out unsigned(9 downto 0)
           );
end syncro_vga;

architecture Behavioral of syncro_vga is

-- Componente contador
component contador_generico is
    Generic( fin_cuenta : integer :=10000000;
             bits_cuenta : integer := 24);           
    
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           pulso : out STD_LOGIC;
           cuenta : out unsigned(bits_cuenta - 1 downto 0));
end component;

-- Componente para las columnas    
component P_fin_col is
    Port ( cont_pxl : in unsigned(9 downto 0);
           hsynch : out STD_LOGIC;
           visible_pxl : out STD_LOGIC;
           new_line : out STD_LOGIC);
end component;

-- Componente para las filas
component P_fin_line is
    Port ( cont_line : in unsigned(9 downto 0);
           vsync : out STD_LOGIC;
           visible_line : out STD_LOGIC);
end component;    
      
   -- Señales a usar
    signal cont_clk : unsigned(1 downto 0);
    signal cont_pxl, cont_line : unsigned(9 downto 0);
    signal new_pxl, new_line, hsynch, visible_pxl, visible_line, and_visible, and_new_line, fin_col : std_logic;
    signal uno_logico : std_logic :='1';
    signal cero_logico : std_logic :='0';
    
begin

   -- Contador para el reloj
    P_cont_clk : contador_generico
        generic map(4, 2)
        port map(
            clk => clk,
            rst => rst,
            enable => uno_logico,
            cuenta => cont_clk,
            pulso => new_pxl);
            
   -- Contador de los pixeles         
    P_cont_pxl : contador_generico
        generic map(c_pxl_total, 10)
        port map(
            clk => clk,
            rst => rst,
            enable => new_pxl,
            cuenta => cont_pxl);
            
            col <= cont_pxl; 
            
    -- Indica si estamos en la zona visible de los pixeles o no         
     P_col_fin : P_fin_col
        port map(   
            cont_pxl => cont_pxl,
            hsynch => hsinc,
            visible_pxl => visible_pxl,
            new_line => new_line);
            
            and_new_line <= new_line and new_pxl;
   
   -- Contador de las líneas             
    P_cont_line : contador_generico
        generic map(c_line_total, 10)
        port map(
            clk => clk,
            rst => rst,
            enable => and_new_line,
            cuenta => cont_line);
            
            fila <= cont_line; 
     
     -- Indica si estamos en la zona visible de las líneas o no          
     P_line_fin : P_fin_line
        port map(
            cont_line => cont_line,
            vsync => vsinc,
            visible_line => visible_line);
            
            visible <= visible_line and visible_pxl;

end Behavioral;
