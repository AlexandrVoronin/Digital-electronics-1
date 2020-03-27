library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic is 
port(
    clk_i:      in  std_logic;
    srst_n_i:   in  std_logic;
    lights_o:   out unsigned(5 downto 0)
    );
end traffic;

architecture Behavioral of traffic is

    type        state_type is (r_red, r_yellow, r_green, g_red, g_yellow, g_green);
    signal      state:  state_type;
    signal 		s_en:	std_logic;
    signal      s_cnt:  unsigned(3 downto 0);
    constant    sec5:   unsigned(3 downto 0) := "1001";
    constant    sec1:   unsigned(3 downto 0) := "0001";
    
begin
  	
  	 CLOCK: entity work.clock_enable
	 generic map
			g_NPERIOD => x"1388"			-- 500ms with 10kHz signal
	 			)
	 port map(
			clk_i    		=> clk_i,  		-- 10 kHz
			srst_n_i 		=> srst_n_i,   	-- Synchronous reset
			clock_enable_o 	=> s_en			
	 		 );
  
    p_traffic: process(clk_i, srst_n_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                s_cnt <= (others => '0');   -- Clear all bits
                state <= r_red;
                
            elsif s_en = '1' then
                case state is
            when r_green =>
                if s_cnt < sec5 then
                    state <= r_green;
                    s_cnt <= s_cnt+1;
                else 
                    state <= r_yellow;
                    s_cnt <= x"0";
                end if;
                
            when r_yellow =>
                if s_cnt < sec1 then
                    state <= r_yellow;
                    s_cnt <= s_cnt+1;
                else 
                    state <= r_red;
                    s_cnt <= x"0";
                end if;
                
            when r_red =>
                if s_cnt < sec1 then
                    state <= r_red;
                    s_cnt <= s_cnt+1;
                else 
                    state <= g_green;
                    s_cnt <= x"0";
                end if;
        
            when g_green =>
                if s_cnt < sec5 then
                    state <= g_green;
                    s_cnt <= s_cnt+1;
                else 
                    state <= g_yellow;
                    s_cnt <= x"0";
                end if;
                
            when g_yellow =>
                if s_cnt < sec1 then
                    state <= g_yellow;
                    s_cnt <= s_cnt+1;
                else 
                    state <= g_red;
                    s_cnt <= x"0";
                end if;
                
            when g_red =>
                if s_cnt < sec1 then
                    state <= g_red;
                    s_cnt <= s_cnt+1;
                else 
                    state <= r_green;
                    s_cnt <= x"0";
                end if;
                end case;
            end if;
        end if;
    end process p_traffic;

    p_out: process(state, lights_o)
    begin
        case state is
            when r_green      => lights_o <= "100001";      -- red      green
            when r_yellow     => lights_o <= "100010";      -- red      yellow
            when r_red        => lights_o <= "100100";      -- red      red
            when g_green      => lights_o <= "001100";      -- green    red
            when g_yellow     => lights_o <= "010100";      -- yellow   red
            when g_red        => lights_o <= "100100";      -- red      red
            when others       => lights_o <= "100001";      -- red      red
        end case;
    end process p_out;
end architecture Behavioral;
