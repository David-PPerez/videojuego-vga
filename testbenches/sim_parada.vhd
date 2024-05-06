----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2024 10:46:03
-- Design Name: 
-- Module Name: sim_parada - Behavioral
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

entity sim_parada is
--  Port ( );
end sim_parada;

architecture Behavioral of sim_parada is

component parada_crono is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        col : in unsigned(4 downto 0);
        fila : in unsigned(4 downto 0);
        parada_crono : out STD_LOGIC);
end component;
 
    signal clk : std_logic := '1';
    signal rst, parada : std_logic;
    signal col, fila : unsigned(4 downto 0);
    constant frecuencia : integer := 100;
    constant periodo : time := 1 us/frecuencia;
begin
    UUT: parada_Crono
        port map(
            clk => clk,
            rst => rst,
            col => col,
            fila => fila,
            parada_crono => parada);
    
    clk <= not(clk) after periodo/2;
    rst <= '1', '0' after 10 ns;
    fila <= "11001";
    col <= "01011", "01100" after 100 ns, "01101" after 150 ns, "01110" after 200 ns, "01111" after 250 ns;
    
end behavioral;