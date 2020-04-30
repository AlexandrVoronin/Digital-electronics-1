library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keypad is 
port(
    clk_i	:   in  std_logic;
    srst_n_i	:   in  std_logic;
    row_i	:   in  unsigned(3 downto 0); --low active with pull up resistors
    col_o	:   out unsigned(2 downto 0); 
    number_o	:   out unsigned(3 downto 0)
    );
end keypad;

architecture Behavioral of keypad is

    type        state_type is (col_1, col_2, col_3);
    signal      state	: state_type;       
    signal      s_en	: std_logic;
    signal 	s_cnt 	: unsigned(16-1 downto 0) := x"0000";
	

begin

     CLOCK: entity work.clock_enable
	 generic map(
			g_NPERIOD => x"0001"			-- 100ms with 10kHz signal
	 			)
	 port map(
			clk_i    	=> clk_i,  		-- 10 kHz
			srst_n_i 	=> srst_n_i,   	-- Synchronous reset
			clock_enable_o 	=> s_en			
	 		 );

    
    p_keypad: process(clk_i)
    begin
        if rising_edge(clk_i) then --rising clock edge
            if srst_n_i = '0' then --synchronous reset (active low)
                s_cnt <= (others => '0'); --clear all bits
                state <= col_1;
                col_o <= "111"; --no key pushed
            elsif s_en = '1' then
            case state is
                when col_1 =>
                col_o <= "011";
                    case row_i is
                        when "0111" => --row 1
                        number_o <= "0001"; --1
                        when "1011" => -- row 2
                        number_o <= "0100"; --4
                        when "1101" => --row 3
                        number_o <= "0111"; --7
                        when "1110" => -- row 4
                        number_o <= "1010"; --*
                        when others => 
                        number_o <= "1111";
                        state <= col_2;
                    end case;
                 when col_2 =>
                 col_o <= "101";
                    case row_i is
                        when "0111" => --row 1
                        number_o <= "0010"; --2
                        when "1011" => -- row 2
                        number_o <= "0101"; --5
                        when "1101" => --row 3
                        number_o <= "1000"; --8
                        when "1110" => -- row 4
                        number_o <= "0000"; --0
                        when others => 
                        state <= col_3;
                        number_o <= "1111";
                    end case;
                 when col_3 =>
                 col_o <= "110";
                    case row_i is
                        when "0111" => --row 1
                        number_o <= "0011"; --3
                        when "1011" => -- row 2
                        number_o <= "0110"; --6
                        when "1101" => --row 3
                        number_o <= "1001"; --9
                        when "1110" => -- row 4
                        number_o <= "1011"; --#
                        when others => 
                        number_o <= "1111";
                        state <= col_1;
                    end case;
                when others => state <= col_1;
            end case;
            end if;
        end if;
    end process p_keypad;
end;
