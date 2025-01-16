library ieee;
use ieee.std_logic_1164.all;

entity mux_3_inputs is
    port (
        clk     : in    std_logic;
        reset   : in    std_logic;
        control : in    std_logic_vector(1 downto 0);
        input_1 : in    std_logic_vector(31 downto 0);
        input_2 : in    std_logic_vector(31 downto 0);
        input_3 : in    std_logic_vector(31 downto 0);
        output  : out   std_logic_vector(31 downto 0)
    );
end entity mux_3_inputs;

architecture rtl of mux_3_inputs is

begin

    mux_3_inputs : process (all) is
    begin

        if (reset = '1') then
            output <= (others => '0');
        else -- Use a latch so that it's executed at the same time with "decode" step.
            if (control = "00") then
                output <= input_1;
            elsif (control = "01") then
                output <= input_2;
            elsif (control = "10") then
                output <= input_3;
            else
                output <= (others => '0');
            end if;
        end if;

    end process mux_3_inputs;

end architecture rtl;
