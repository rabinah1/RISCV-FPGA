library ieee;
use ieee.std_logic_1164.all;

entity mux_2_inputs_latch is
    port (
        reset   : in    std_logic;
        control : in    std_logic;
        input_1 : in    std_logic_vector(31 downto 0);
        input_2 : in    std_logic_vector(31 downto 0);
        halt    : in    std_logic;
        output  : out   std_logic_vector(31 downto 0)
    );
end entity mux_2_inputs_latch;

architecture rtl of mux_2_inputs_latch is

begin

    mux_2_inputs_latch : process (all) is
    begin

        if (reset = '1' or halt = '1') then
            output <= (others => '0');
        else -- Use a latch so that it's executed at the same time with "decode" step.
            if (control = '0') then
                output <= input_1;
            elsif (control = '1') then
                output <= input_2;
            else
                output <= (others => '0');
            end if;
        end if;

    end process mux_2_inputs_latch;

end architecture rtl;
