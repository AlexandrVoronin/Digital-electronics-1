library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for top level
    ------------------------------------------------------------------------
entity top is

    port (
        clk_i            : in  std_logic;     -- 10 kHz clock signal
        BTN0             : in  std_logic;     -- Synchronous reset
        R0, R1, R2, R3   : in  std_logic;     -- Rows input
        C0, C1, C2       : out std_logic;     -- Columns output
        LD3,LD2,LD1,LD0  : out std_logic
    );
end entity top;

------------------------------------------------------------------------
-- Architecture declaration for top level
------------------------------------------------------------------------
architecture Behavioral of top is
    
    signal s_BTN0       :  std_logic;
    signal s_row_i      :  unsigned(3 downto 0);
    signal s_col_o      :  unsigned(2 downto 0);
    signal code_state   :  unsigned(15 downto 0);  -- *see bellow
    signal s_alarm      :  unsigned(3 downto 0);
    signal s_number     :  unsigned(3 downto 0)

    begin
        
        s_BTN0      <=  BTN0;
        
        s_row_i(3)  <=  R3;
        s_row_i(2)  <=  R2;
        s_row_i(1)  <=  R1;
        s_row_i(0)  <=  R0;
        
        s_col_o(2)  <=  C2;
        s_col_o(1)  <=  C1;
        s_col_o(0)  <=  C0;

    --------------------------------------------------------------------
    
    CODE_LOCK: entity work.code_lock

        port map(
            clk_i       =>  clk_i,
            srst_n_i    =>  s_BTN0,
            row_i       =>  s_row_i,
            col_o       =>  s_col_o,
            state_o     =>  code_state,
            alarm_o     =>  s_alarm
        );
        
    --------------------------------------------------------------------

        LD3 <= not s_alarm(3);
        LD2 <= not s_alarm(2); 
        LD1 <= not s_alarm(1);
        LD0 <= not s_alarm(0);  	


end architecture Behavioral;

--* Not sure how to deal with the state_o in top, as it is there only to visualize the p_lock process in codel_lock.vhd (would leave it out otherwise)
