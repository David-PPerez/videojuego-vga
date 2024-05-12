----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.04.2024 20:50:52
-- Design Name: 
-- Module Name: sim_jugador - Behavioral
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
use WORK.RACETRACK_PKG.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_jugador is
--  Port ( );
end sim_jugador;

architecture Behavioral of sim_jugador is
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
    signal clk, vel : std_logic := '1';
    signal rst,  play, jug_pista : std_logic ;
    signal pulso_derecha, pulso_izquierda, pulso_arriba, pulso_abajo : std_logic;
    signal col_jugador, fila_jugador : unsigned(4 downto 0);
    constant frecuencia : integer := 100;
    constant periodo : time := 1 us/frecuencia;
   signal pulsos : std_logic_vector(3 downto 0);
begin
    UUT : fsm_jugador
        port map(
            clk => clk,
            rst => rst,
            vel => vel,
            play => play,
            pulsos => pulsos,
            jug_pista => jug_pista,
            col_jugador => col_jugador,
            fila_jugador => fila_jugador);
    
    clk <= not(clk) after periodo/2;
    rst <= '1', '0' after 10 ns;
    vel <= not(vel) after periodo;
    play <= '0', '1' after 20 ns;
    pulso_derecha <= '0', '1' after 80 ns, '0' after 280 ns; 
    pulso_izquierda <= '0', '1' after 340 ns, '0' after 600 ns; 
    pulso_arriba <= '0', '1' after 160 ns, '0' after 450 ns; 
    pulso_abajo <= '0', '1' after 500 ns, '0' after 700 ns; 
    pulsos <= pulso_derecha & pulso_abajo & pulso_izquierda & pulso_arriba;
end Behavioral;
