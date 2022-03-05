LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity state_board is
port(SW: in std_logic_vector(9 downto 0); 
KEY: in std_logic_vector(3 downto 0);
LEDR: out std_logic_vector(9 downto 0));
--HEX5: out std_logic_vector(6 downto 0);
--HEX4: out std_logic_vector(6 downto 0);
--HEX3: out std_logic_vector(6 downto 0);
--HEX2: out std_logic_vector(6 downto 0);
--HEX1: out std_logic_vector(6 downto 0);
--HEX0: out std_logic_vector(6 downto 0));
end state_board;

--Begin the architecture,
architecture board of state_board is
-------------------------------------------------
component statemachine is
port( 
a: IN std_logic;
b: IN std_logic;
clk: IN std_logic;
rst: IN std_logic;
ivalid: IN std_logic;
unl: OUT std_logic);
end component statemachine;
--------------------------------------------------
begin
	
	board_map: component statemachine
	port map(a => SW(1),
	b => SW(0),
	clk => KEY(3),
	rst => SW(9),
	ivalid => SW(8),
	unl => LEDR(5));
	--sg2 => HEX5);
	--sg1 => HEX4,
	--sg4 => HEX3,
	--sg3 => HEX2,
	--sg6 => HEX1,
	--sg5 => HEX0);
	
end board;