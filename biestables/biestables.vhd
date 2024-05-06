----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2024 18:22:29
-- Design Name: 
-- Module Name: biestables - Behavioral
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

-- Esta implementación es la de un detector de flanco, formado por dos biestables tipo d y uno tipo t
entity biestables is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           q : out STD_LOGIC);
end biestables;

architecture Behavioral of biestables is
-- La señal definida es la intermedia entre los biestables tipo d y el tipo t
    signal pulso1 : std_logic;
    
-- Llamamos a la implementación del biestable tipo d    
    component biestablesd is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulso : out STD_LOGIC);
    end component;
    
-- Llamamos a la implementación del biestable tipo t
    component biestablet is
    Port ( t : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           q : out STD_LOGIC);
    end component;
begin

-- Hay que enlazar las entradas, señales y salidas de mi implementación a los demás componentes
    detector_flanco: biestablesd 
                port map (
                    btn => btn,
                    clk => clk,
                    rst => rst,
                    pulso => pulso1);
    biestable_t: biestablet 
                port map (
                    t => pulso1,
                    clk => clk,
                    rst => rst,
                    q => q);
                    
end Behavioral;
