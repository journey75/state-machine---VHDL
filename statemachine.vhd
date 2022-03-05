--lab 2 - state machine
LIBRARY ieee;
USE ieee.std_logic_1164.all;
entity statemachine is
port( a: IN std_logic;
b: IN std_logic;
clk: IN std_logic;
rst: IN std_logic;
ivalid: IN std_logic;
unl: OUT std_logic);
end statemachine;

--Begin the architecture,
architecture states of statemachine is
	TYPE state is (acheck1,dlow1,bcheck,dlow2,acheck2,dlow3,acheck3,ulock,rstcheck); --(A,B,C,D,F,G,H,I,J);
	signal current_state : state;
begin
		
		--ONLY transition logic
	process(clk,rst) begin
		if(rst = '1') then
			current_state <= acheck1;
		elsif(rising_edge(clk) AND ivalid = '1') then
			case current_state is
				when acheck1 =>  
					if a = '1' and b = '0'  then current_state <= dlow1; --we need a high a to proceed
					else current_state <= acheck1; end if;
				when dlow1 =>
					if a = '0' and b = '0' then current_state <= bcheck; --we need at least 2 lows to proceed
					elsif a = '1' and b = '0' then current_state <= dlow1; --if they do another A, then we are still ok
					else current_state <= acheck1; end if;
				when bcheck =>
					if a = '0' and b = '1' then current_state <= dlow2; --we need a high B to proceed
					elsif a = '0' and b = '0' then current_state <= bcheck; --if they do another  double low then we are still ok
					else current_state <= acheck1; end if;
				when dlow2 =>
					if a = '0' and b = '0' then current_state <= acheck2; --we need at least 2 lows to proceed
					else current_state <= acheck1; end if; --if they do anything other than a double low after a and b, then it trips the reset
				when acheck2 =>
					if a = '0' and b = '0' then current_state <= acheck2; --if they do another  low, we are still fine
					elsif a = '1' and b = '0' then current_state <= dlow3; --we need a high a to proceed
					else current_state <= acheck1; end if;
				when dlow3 =>
					if a = '0' and b = '0' then current_state <= acheck3; --need a double low to proceed
					else current_state <= acheck1; end if;--anything other than double low is a reset
				when acheck3 =>
					if a = '0' and b = '0' then current_state <= acheck3;
					elsif a = '0' and b = '1' then current_state <= acheck2;	--a 2nd be would make ab, so we can start from there
					elsif a = '1' and b = '0' then current_state <= ulock; --need a high a to proceed
					else current_state <= acheck1; end if;--anything other than an a or a double low means a reset
				when ulock =>
					if a = '0' and b = '0' then current_state <= rstcheck;
					elsif a = '1' and b = '0' then current_state <= ulock;
					elsif a = '0' and b = '1' then current_state <= acheck1;
					elsif a = '1' and b = '1' then current_state <= acheck1;
					--unl <= '1';--if we get here, we are good to unlock (?)
					--current_state <= rstcheck;
					else current_state <= acheck1;
					end if;
				when rstcheck =>
					if a = '1' or b ='1' then current_state <= acheck1;
					--if a = '1' or b ='1' then unl <= '0';
					--current_state <= acheck1;
					end if;
					
				--default case for something unexpected
				when others => 
					current_state <= acheck1;
					
			end case;
		end if;
	end process;
					
	unl <= '1' when (current_state = ulock or current_state  = rstcheck) else '0';				
					
	
end states;