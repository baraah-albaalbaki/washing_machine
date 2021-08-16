library ieee;
use ieee.std_logic_1164.all; 

entity pro is
port(clk, reset, start: in std_logic;
    full: in std_logic:='0';
    empty: in std_logic:='1';

    in_vlv, out_vlv: out std_logic:='0';
    motor_fwd, motor_rev, lock_door, alarm: out std_logic:='0');
end pro;

architecture arch of pro is 
    type stateFSM is (filling, stand, washing, draining, rinsing, spinning, finish); 
    signal current_state, next_state: stateFSM:=stand;
    signal washing_done, rinsing_done, spinning_done, alrt: std_logic:='0';
begin 
    P1: process(clk, reset)
    begin
        if (reset = '1') then
            current_state <= stand;
        elsif (clk'event and clk = '1') then 
            current_state <= next_state;
        end if; 
    end process;

    P2: process(start, full,empty, washing_done, rinsing_done, spinning_done, alrt)
    begin 
        case current_state is 
            when stand =>  
                if (start = '1') then 
                    next_state <= filling; 
		else next_state <= stand;
		end if;
            when filling =>  
                if (full = '1') then
		    if (washing_done = '0') then
                    	next_state <= washing;
                    else next_state <= rinsing;
		    end if;
		else next_state <= filling;
		end if;
            when washing =>  
                if (washing_done = '1') then
                    next_state <= draining;
		else next_state <= washing;
                end if;
            when draining =>  
                if (empty = '1') then
		    if (rinsing_done = '1') then 
                    	next_state <= spinning;
		    else next_state <= filling;
		    end if;
		else next_state <= draining;
                end if;
            when rinsing =>  
                if (rinsing_done = '1') then
                    next_state <= draining;
		else next_state <= rinsing;
                end if;
            when spinning=>  
                if (spinning_done = '1') then
                    next_state <= finish;
		else next_state <= spinning;
                end if;
            when finish=>
		if (alrt = '1') then
                    next_state <= stand;
		end if;
        end case; 
    end process;

    P3: process
    begin
        if (reset = '1') then
		in_vlv <= '0';
		out_vlv<= '0';
		motor_fwd <= '0';
		motor_rev <= '0';
	end if;
        wait until clk'event and clk = '1';
            case next_state is
            when stand =>
		washing_done <= '0'; rinsing_done <= '0'; spinning_done <= '0';
		in_vlv <= '0';
		out_vlv <= '0';
		motor_fwd <= '0';
		alrt <= '0';
            when filling =>
		in_vlv <= '1';
		out_vlv<= '0';
		motor_fwd <= '0';
            when washing =>
		in_vlv <= '0';
		out_vlv<= '0';
                for i in 0 to 3 loop
                    motor_fwd <= '1'; motor_rev <= '0';
                    wait for 100ps;
                    motor_rev <= '1'; motor_fwd <= '0';
                    wait for 100ps;
                end loop;
		washing_done <= '1';
		motor_fwd <= '1';
            when draining =>
                out_vlv <= '1';
		in_vlv <= '0';
		motor_fwd <= '0';
            when rinsing =>
		in_vlv <='0';  
		out_vlv <= '0';
                for k in 0 to 3 loop
                    motor_fwd <= '1'; motor_rev <= '0';
                    wait for 200ps;
                    motor_rev <= '1'; motor_fwd <= '0';
                    wait for 100ps;
                end loop;
	        motor_rev <= '0'; motor_fwd <= '0';
         	rinsing_done <= '1';
            when spinning =>
                out_vlv <= '1'; 
		lock_door <= '1';
                motor_fwd <= '1'; motor_rev <= '0';
                wait for 200ps;
	        motor_fwd <= '0';
		spinning_done <= '1';
            when finish =>
		lock_door <= '0';
		alarm <= '1';
		wait for 200ps;
		alarm <= '0';
		alrt <= '1';
        end case; 

end process;
end arch;
