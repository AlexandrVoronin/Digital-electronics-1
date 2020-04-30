library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lock is 
port(
    clk_i   :   in  std_logic;
    srst_n_i:   in  std_logic;
    row_i   :   in  unsigned(3 downto 0); --low active with pull up resistors
    col_o   :   out unsigned(2 downto 0);
    state_o :	out unsigned(15 downto 0);
    alarm_o :   out unsigned(3 downto 0)  --output signalization /wrong code/
    );
end lock;

architecture Behavioral of lock is

    type        state_type is (rel_0, ent_1, rel_1, ent_2, rel_2, ent_3, rel_3, ent_4, rel_4, enter, wrong_code, alarm, code_unlocked, time_up);
    signal      code_state, next_code_state :       state_type;         
    signal      s_en                        :       std_logic;
    signal      number_pressed              :       unsigned(3 downto 0);           --assign number to detected key
    signal      start_count                 :       std_logic;
    signal      start_blink                 :       std_logic;
    signal      s_time_up                   :       std_logic;
    signal      count_time                  :       unsigned(3 downto 0);           --helps count the passed input time
    signal      s_blink                     :       unsigned(1 downto 0);
    
    --set your own input time--
    constant    input_time:                         unsigned(3 downto 0) := "1001"; --5 seconds to enter code
    
    -- change the code here --
    constant    first_num:                          unsigned(3 downto 0) := "0010"; --#1 number of code
    constant    second_num:                         unsigned(3 downto 0) := "0100"; --#2 number of code
    constant    third_num:                          unsigned(3 downto 0) := "1001"; --#3 number of code
    constant    fourth_num:                         unsigned(3 downto 0) := "0000"; --#4 number of code

begin
    CLOCK: entity work.clock_enable
    generic map(
    --for simulation in EDA Playground--
      g_NPERIOD => x"0030" --see correct code entered and wrong code entered
      --g_NPERIOD => x"0020" --see what happens if time is up without changing testbech times
    --real life scenario--
      --g_NPERIOD => x"1388" --500ms with 10kHz clock 
    )
    port map(
        clk_i           =>  clk_i, --10kHz
        srst_n_i        =>  srst_n_i, --synchronous reset
        clock_enable_o	=>  s_en
    );
    
    KEYPAD: entity work.keypad
    port map(
        clk_i           =>  clk_i,
        srst_n_i        =>  srst_n_i,
        number_o        =>  number_pressed,
        row_i           =>  row_i,
        col_o           =>  col_o
    );
    
    -- Unlocking process --
    
    p_lock: process(clk_i)
    begin
   
        if rising_edge(clk_i) then --rising clock edge
        
            code_state <= next_code_state;
        
            if srst_n_i = '0' then --synchronous reset (active low)
                code_state 	<= rel_0; --start from beginning
                count_time 	<= "0000";
                alarm_o  	<= "1111";
                start_count <= '0';
                s_time_up  	<= '0';
                start_blink <= '0';
                s_blink		<= "00";
            elsif s_en = '1' then                                           --rising_edge with own period to count_time
                
                if start_count = '1' then                                   --when start_count set to 1 start counting time
                    if count_time < input_time then
                        count_time <= count_time+1;
                    else                                                    --if time is up s_time_up set to 1
                        s_time_up <= '1'; 
                    end if;
                end if;
                
                if start_blink <= '1' then                                  --blinking signal for unlocked and alarm leds
                    if s_blink < "01" then
                        s_blink <= s_blink+1;
                    else
                        s_blink <= "00";
                    end if;
                else
                    s_blink <= "00";
                end if;
                
            else                                                            --rising_edge with clk_i signal
                case code_state is   
                
                    when rel_0 => state_o <= x"0001";                       --wait for pressed key
                        alarm_o <= "1111";                                  --set off alarm
                        start_blink <= '0';
                        s_blink <= "00";
                        if number_pressed = "1111" then                     --if none is pressed
                            next_code_state <= rel_0;
                        elsif number_pressed = "1010" then                  --if previous code was alarm (1010 reset the alarm with * - 1010)
                            next_code_state <= rel_0;
                        else                                                --enter first number
                            next_code_state <= ent_1;
                            start_count <= '1';                             --when first number entered start counting time
                        end if;
                    
                    when ent_1 => state_o <= x"0002";                       
                        if s_time_up = '0' then
                            if number_pressed = first_num then              --#1 number of code
                                next_code_state <= rel_1;
                                alarm_o <= "0111";                          --signalize 1st input
                            else next_code_state <= wrong_code;             --if wrong key pressed move to wrong_code
                            end if;
                        else next_code_state <= time_up;
                        end if;
                    
                    when rel_1 => state_o <= x"0003";                       --wait till key is released 
                        if s_time_up = '0' then
                            if number_pressed = first_num then
                                next_code_state <= rel_1;
                            elsif number_pressed = "1111" then
                                next_code_state <=ent_2;                    --when key is released move to next state to enter #2 number
                            else next_code_state <= wrong_code;
                            end if;
                        else next_code_state <= time_up;
                        end if;
                    
                    when ent_2 => state_o <= x"0004";                       --same princip as ent_1
                        if s_time_up = '0' then
                            if number_pressed = second_num then                 
                                next_code_state <= rel_2;
                                alarm_o <= "0011";                          --signalize 2nd input
                            elsif number_pressed = "1111" then
                                next_code_state <= ent_2;
                            else next_code_state <= wrong_code;
                            end if;
                        else next_code_state <= time_up;
                        end if;
                        
                    when rel_2 => state_o <= x"0005";                       --same princip as rel_1  
                        if s_time_up = '0' then
                            if number_pressed = second_num then
                                next_code_state <= rel_2;
                            elsif number_pressed = "1111" then
                                next_code_state <=ent_3;
                            else next_code_state <= wrong_code;
                            end if;
                        else next_code_state <= time_up;
                        end if;
                        
                    when ent_3 => state_o <= x"0006";                       --same princip as ent_1
                        if s_time_up = '0' then
                            if number_pressed = third_num then                 
                                next_code_state <= rel_3;
                                alarm_o <= "0001";                          --signalize 3rd input
                            elsif number_pressed = "1111" then
                                next_code_state <= ent_3;
                            else next_code_state <= wrong_code;
                            end if;
                        else next_code_state <= time_up;
                        end if;
                        
                    when rel_3 => state_o <= x"0007";                       --same princip as rel_1   
                        if s_time_up = '0' then
                            if number_pressed = third_num then             
                                next_code_state <= rel_3;
                            elsif number_pressed = "1111" then
                                next_code_state <= ent_4;
                            else next_code_state <= wrong_code;
                            end if;
                        else next_code_state <= time_up;
                        end if;
                        
                    when ent_4 => state_o <= x"0008";                       --same princip as ent_1
                        if s_time_up = '0' then
                            if number_pressed = fourth_num then                 
                                next_code_state <= rel_4;
                                alarm_o <= "0000";                          --signalize 4th input
                            elsif number_pressed = "1111" then
                                next_code_state <= ent_4;
                            else next_code_state <= wrong_code;
                            end if;
                        else next_code_state <= time_up;
                        end if;
                        
                    when rel_4 => state_o <= x"0009";                       --same princip as rel_1   
                        if s_time_up = '0' then
                            if number_pressed = fourth_num then
                                next_code_state <= rel_4;
                            elsif number_pressed = "1111" then
                                next_code_state <= enter;
                            else next_code_state <= wrong_code;
                            end if;
                        else next_code_state <= time_up;
                        end if;
                        
                    when wrong_code => state_o <= x"0010";                  --wrong code entered in any phase
                        if s_time_up = '0' then
                            if number_pressed = "1011" then                 --wait for # pressed (enter)  
                                next_code_state <= alarm;                   --start alarm
                            else next_code_state <= wrong_code;
                            end if;
                        else next_code_state <= time_up;
                        end if;
                                                
                    when enter => state_o <= x"0011";                       --whole code entered right
                        if s_time_up = '0' then
                            if number_pressed = "1011" then                 --if # pressed (enter) go to code_unlocked
                                count_time <= "0000";                       --reset count_time
                                start_count <= '1';
                                next_code_state <= code_unlocked;
                            elsif number_pressed = "1111" then              --wait for key press
                                next_code_state <= enter;                   
                            else next_code_state <= alarm;                  --if other key is pressed start alarm
                            end if;
                        else next_code_state <= time_up;
                        end if;
                        
                    when alarm => state_o <= x"0012";                       --when wrong code entered
                        s_time_up <= '0';                                   --stop counting time
                        start_count <= '0';                                 --reset count_time
                        start_blink <= '1';
                        count_time <= "0000";
                        if number_pressed /= "1010" then                    --if * isn't pressed start alarm
                            if s_blink = "00"  then
                                alarm_o <= "1111";
                            else 
                                alarm_o <= "0000";
                            end if;
                            next_code_state <= alarm;                       
                        else
                            alarm_o <= "1111";                              --else if * was pressed go back to rel_0
                            next_code_state <= rel_0;
                        end if;
                    when time_up => state_o <= x"0013";                     --if it took too long to enter code
                        s_time_up <= '0';                                   --reset all values
                        start_count <= '0';
                        alarm_o <= "1111";                                  
                        count_time <= "0000";               
                        next_code_state <= rel_0;                           --go to rel_0 / wait till code is entered again
                        
                    when code_unlocked => state_o <= x"0014";               --unlock the lock
                        if count_time < "1000" then                         --count unlocked time 
                        	start_blink <= '1';
                            next_code_state <= code_unlocked;
                            if s_blink = "00"  then                         --signalization for unlocked state
                                alarm_o <= "1110";
                            else 
                                alarm_o <= "1111";
                            end if;
                        else
                            next_code_state <= time_up;                     --if unlocked time is up go to time_up
                        end if;
                end case;
            end if;
        end if;
    end process p_lock;
end architecture Behavioral;
