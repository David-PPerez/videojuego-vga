----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2024 14:31:05
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
 component top is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           play : in std_logic;
           btnR, btnL, btnU, btnD : in std_logic;           
           rojo : out std_logic_vector(3 downto 0);
           verde : out std_logic_vector(3 downto 0);
           azul : out std_logic_vector(3 downto 0);
           hsinc : out std_logic;
           vsinc : out std_logic);
end component;

    signal clk : std_logic := '1';
    signal rst, hsinc, vsinc, play, btnR, btnL, btnU, btnD : std_logic;
    signal rojo, verde, azul: std_logic_vector(3 downto 0);
    constant frecuencia : integer := 100;
    constant periodo : time := 1 us/frecuencia;
begin
UUT : top
    port map(
        clk => clk, 
        rst => rst,
        play => play,
        btnR => btnR,
        btnL => btnL,
        btnU => btnU,
        btnD => btnD,        
        rojo => rojo,
        verde => verde,
        azul => azul,
        hsinc => hsinc,
        vsinc => vsinc);
    clk <= not(clk) after periodo/2;
    rst <= '1', '0' after 1 ns;
    play <= '0', '1' after 20 ns, '0' after 21 ns;
    btnR <= '0', '1' after 15ns, '0' after 25 ns, '1' after 135ns, '0' after 155 ns;
    btnL <= '0', '1' after 65ns, '0' after 75 ns, '1' after 200ns, '0' after 250 ns;
    btnU <= '0', '1' after 105ns, '0' after 115 ns, '1' after 220ns, '0' after 270 ns;
    btnD <= '0', '1' after 135ns, '0' after 145 ns;
        

end Behavioral;
