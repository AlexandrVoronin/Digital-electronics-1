------------------------------------------------------------------------
--
-- Implementation of 4-bit binary counter.
-- Xilinx XC2C256-TQ144 CPLD, ISE Design Suite 14.7
--
-- Copyright (c) 2019-2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for top level
------------------------------------------------------------------------
entity top is
	
	port (
		 clk_i      : in  std_logic;     -- 10 kHz clock signal
		 BTN0       : in  std_logic;     -- Synchronous reset
		 disp_seg_o : out std_logic_vector(7-1 downto 0);
		 disp_dig_o : out std_logic_vector(4-1 downto 0);
		 LD3,LD2,LD1,LD0 : out std_logic
	);
end entity top;

------------------------------------------------------------------------
-- Architecture declaration for top level
------------------------------------------------------------------------
architecture Behavioral of top is
    constant c_NBIT0 : positive := 4;   -- Number of bits for Counter0
	 signal s_BTN0: std_logic;
	 signal s_en: std_logic; 
	 signal s_hex: std_logic_vector(4-1 downto 0);
	 begin
	
			s_BTN0 <= BTN0;
    --------------------------------------------------------------------
    CL_ENABLE: entity work.clock_enable
		 generic map (
		 g_NPERIOD => x"09c4"
		)
		port map(srst_n_i => s_BTN0,
					clk_i => clk_i,
					clock_enable_o => s_en	
		);


    --------------------------------------------------------------------
    BINARY_CNT: entity work.binary_cnt
	  generic map (
		 g_NBIT => 4
		)
	  port map(srst_n_i => s_BTN0,
				  en_i => s_en,
				  clk_i => clk_i,
				  cnt_o => s_hex
		);




    --------------------------------------------------------------------
    HEX_TO_7SEG: entity work.hex_to_7seg
		port map( hex_i => s_hex,
					seg_o => disp_seg_o
		);

    disp_dig_o <= "1110";
	 
	LD3 <= not s_hex(3);
	LD2 <= not s_hex(2); 
	LD1 <= not s_hex(1);
	LD0 <= not s_hex(0);  	
	

end architecture Behavioral;
