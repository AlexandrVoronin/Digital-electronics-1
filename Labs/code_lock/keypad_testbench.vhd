library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
--empty
end testbench;

architecture tb of testbench is
  -- DUT component
  component keypad is
  port(
	-- INPUTS
	clk_i    : in  std_logic;
    	srst_n_i : in  std_logic;   -- Synchronous reset (active low)
    	row_i	 : in  unsigned(3 downto 0);
    	-- OUTPUTS
    	col_o	 : out unsigned(2 downto 0);
    	number_o:    out unsigned(3 downto 0)
    
  );
  end component;

  signal clk_in   	: std_logic := '0'; 
  signal srst_n_in 	: std_logic := '0';
  signal row_in		: unsigned(3 downto 0 );
  signal col_out	: unsigned(2 downto 0 );
  signal number_out	: unsigned(3 downto 0 );
  
  BEGIN
	UUT: keypad port map(
      		clk_i => clk_in,
      		srst_n_i => srst_n_in,
     		row_i => row_in,
      		col_o	=> col_out,
      		number_o => number_out 
      
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
      
      row_in <= "1111"; wait for 92 ns;
      
      row_in <= "0111"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "0111"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "0111"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      
      row_in <= "1011"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "1011"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "1011"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      
      row_in <= "1101"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "1101"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "1101"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      
      row_in <= "1110"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "1110"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "1110"; wait for 50 ns;
      row_in <= "1111"; wait for 10 ns;
      row_in <= "1110"; wait for 50 ns;
      
      wait;
   end process;
end tb;
