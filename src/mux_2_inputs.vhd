library ieee;
use ieee.std_logic_1164.all;

entity mux_2_inputs is
    port (
        clk     : in    std_logic;
        reset   : in    std_logic;
        control : in    std_logic;
        input_1 : in    std_logic_vector(31 downto 0);
        input_2 : in    std_logic_vector(31 downto 0);
        output  : out   std_logic_vector(31 downto 0)
    );
end entity mux_2_inputs;

architecture rtl of mux_2_inputs is

begin

    mux_2_inputs : process (all) is
    begin

        if (reset = '1') then
            output <= (others => '0');
        elsif (falling_edge(clk)) then
            if (control = '0') then
                output <= input_1;
            else
                output <= input_2;
            end if;
        end if;

    end process mux_2_inputs;

end architecture rtl;
