----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2024 10:16:34
-- Design Name: 
-- Module Name: fondos - Behavioral
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

-- Declaración de entradas y salidas
entity fondos is
    port(
        clk : in std_logic;
        fila_comp : in unsigned(4 downto 0);
        col_comp : in unsigned(4 downto 0);
        rojo_fondo, verde_fondo, azul_fondo: out std_logic);
end fondos;

architecture Behavioral of fondos is
  -- Componentes para para pintar la pista y el fondo
    component ROM1b_1f_red_racetrack_1 is
    port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(5-1 downto 0);
    dout : out std_logic_vector(32-1 downto 0));
    end component;
    
    component ROM1b_1f_green_racetrack_1 is
    port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(5-1 downto 0);
    dout : out std_logic_vector(32-1 downto 0));
    end component;
    
    component ROM1b_1f_blue_racetrack_1 is
    port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(5-1 downto 0);
    dout : out std_logic_vector(32-1 downto 0));
    end component;
    
    component mux32 is
    Port ( selector : in STD_LOGIC_VECTOR (4 downto 0);
           data : in STD_LOGIC_VECTOR (31 downto 0);
           Y : out STD_LOGIC);
    end component;
    
    signal memo_rojo_fondo, memo_verde_fondo, memo_azul_fondo : std_logic_vector(32-1 downto 0);

begin
   -- Relaciones para pintar los distintos colores de la pista y el fondo
    pista_rojo: ROM1b_1f_red_racetrack_1
        port map (
            clk => clk,
            addr => std_logic_vector(fila_comp),
            dout => memo_rojo_fondo);
            
    mux_pista_rojo: mux32
        port map(
            selector => std_logic_vector(col_comp),
            data => memo_rojo_fondo,
            Y => rojo_fondo);            

    pista_verde: ROM1b_1f_green_racetrack_1
        port map (
            clk => clk,
            addr => std_logic_vector(fila_comp),
            dout => memo_verde_fondo);
            
    mux_pista_verde: mux32
        port map(
            selector => std_logic_vector(col_comp),
            data => memo_verde_fondo,
            Y => verde_fondo);            

    pista_azul: ROM1b_1f_blue_racetrack_1
        port map (
            clk => clk,
            addr => std_logic_vector(fila_comp),
            dout => memo_azul_fondo);
            
    mux_pista_azul: mux32
        port map(
            selector => std_logic_vector(col_comp),
            data => memo_azul_fondo,
            Y => azul_fondo);

end Behavioral;
