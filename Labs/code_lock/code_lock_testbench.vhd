library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
--empty
end testbench;

architecture tb of testbench is
  -- DUT component
  component lock is
  port(
	-- INPUTS
	clk_i:		 in  	std_logic;
    	srst_n_i:	 in  	std_logic;   -- Synchronous reset (active low)
    	row_i:		 in  	unsigned(3 downto 0);
    	-- OUTPUTS
    	col_o:       	 out    unsigned(2 downto 0);
    	state_o:	 out    unsigned(15 downto 0);
    	alarm_o:	 out 	unsigned(3 downto 0)
    
  );
  end component;

  signal clk_in   	: std_logic := '0'; 
  signal srst_n_in 	: std_logic := '0';
  signal row_in		: unsigned(3 downto 0 );
  signal col_out	: unsigned(2 downto 0 );
  signal state_out	: unsigned(15 downto 0 );
  signal alarm_out	: unsigned(3 downto 0 );
  
  
  BEGIN
	UUT: lock port map(
      		clk_i    => clk_in,
      		srst_n_i => srst_n_in,
     		row_i    => row_in,
      		col_o    => col_out,
      		state_o  => state_out,
      		alarm_o  => alarm_out
    );
	

	Clk_gen: process	
  	begin
    	while Now < 1000 ns loop
      		clk_in <= '0';
      		wait for 0.5 ns;
      		clk_in <= '1';
      		wait for 0.5 ns;
    	end loop;
    	wait;
  	end process Clk_gen;	
  	
   
   -- Stimulus process
   stim_proc: process
   begin	
   	  
      srst_n_in <= '1';
      wait until rising_edge(clk_in);
      wait until rising_edge(clk_in);
      srst_n_in <= '0';
      wait until rising_edge(clk_in);
      wait until rising_edge(clk_in);
      wait until rising_edge(clk_in);
      srst_n_in <= '1';
      
      row_in <= "1111"; wait for 50 ns;
      row_in <= "0111"; wait for 50 ns; --2
      
      row_in <= "1111"; wait for 50 ns;
      row_in <= "1011"; wait for 50 ns; --4
      
      row_in <= "1111"; wait for 50 ns;
      row_in <= "1101"; wait for 50 ns; --9
      
      row_in <= "1111"; wait for 50 ns;
      row_in <= "1110"; wait for 50 ns; --0
      
      row_in <= "1111"; wait for 55 ns;
      row_in <= "1110"; wait for 50 ns; --# enter
      
      row_in <= "1111"; wait for 50 ns;
      row_in <= "0111"; wait for 50 ns; --2
      
      row_in <= "1111"; wait for 50 ns;
      row_in <= "1011"; wait for 50 ns; --4
      
      row_in <= "1111"; wait for 35 ns;
      row_in <= "1110"; wait for 65 ns; --#
      
      row_in <= "1111"; wait for 55 ns;
      row_in <= "1110"; wait for 10 ns; --* set alarm off
      
      row_in <= "1111"; wait for 10 ns;
      row_in <= "0111"; wait for 10 ns; --2
      
      wait;
   end process;
end tb;
