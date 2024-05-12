----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.04.2024 12:56:42
-- Design Name: 
-- Module Name: sim - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim is
--  Port ( );
end sim;

architecture Behavioral of sim is
component fsm_bordeo is
  Port (
        clk : in std_logic;
        rst : in std_logic;
        vel : in std_logic;
        play: in std_logic;
        col_bordeo : out unsigned(4 downto 0);
        fila_bordeo : out unsigned(4 downto 0));
end component;

signal clk, vel : std_logic := '1';
signal rst,  play : std_logic ;
signal col_bordeo, fila_bordeo : unsigned(4 downto 0);
constant frecuencia : integer := 100;
constant periodo : time := 1 us/frecuencia;
begin
    UUT: fsm_bordeo
        port map(
            clk => clk,
            rst => rst,
            vel => vel,
            play => play,
            col_bordeo => col_bordeo,
            fila_bordeo => fila_bordeo);
    clk <= not(clk) after periodo/2;
    rst <= '1', '0' after 10 ns;
    vel <= not(vel) after periodo;
    play <= '0', '1' after 20 ns;  
end Behavioral;
