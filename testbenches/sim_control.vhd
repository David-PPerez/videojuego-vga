----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2024 16:40:30
-- Design Name: 
-- Module Name: sim_control - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_control is
--  Port ( );
end sim_control;

architecture Behavioral of sim_control is
    component control_jugador is
  Port (
        clk : in std_logic;
        rst : in std_logic;
        btnR, btnL, btnU, btnD : in std_logic;
        pulsos : out std_logic_vector(3 downto 0));
    end component;
    signal clk : std_logic := '1';
    signal rst, btnR, btnL, btnU, btnD : std_logic;
    signal pulsos : std_logic_vector(3 downto 0);
    constant frecuencia : integer := 100;
    constant periodo : time := 1 us/frecuencia;
begin
    UUT: control_jugador
        port map(
            clk => clk,
            rst => rst,
            btnR => btnR,
            btnL => btnL,
            btnU => btnU,
            btnD => btnD,
            pulsos => pulsos);
    
    clk <= not(clk) after periodo/2;
    rst <= '1', '0' after 10 ns;
    btnR <= '0', '1' after 15ns, '0' after 25 ns, '1' after 135ns, '0' after 155 ns;
    btnL <= '0', '1' after 65ns, '0' after 75 ns, '1' after 200ns, '0' after 250 ns;
    btnU <= '0', '1' after 105ns, '0' after 115 ns, '1' after 220ns, '0' after 270 ns;
    btnD <= '0', '1' after 135ns, '0' after 145 ns;

end Behavioral;
