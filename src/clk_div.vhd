library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity clk_div is
    port (
        clk_in     : in    std_logic;
        reset      : in    std_logic;
        clk_500khz : out   std_logic
    );
end entity clk_div;

architecture rtl of clk_div is

    signal counter : integer range 0 to 49 := 0;

begin

    clk_div : process (all) is
    begin

        if (reset = '1') then
            clk_500khz <= '0';
            counter    <= 0;
        elsif (rising_edge(clk_in)) then
            if (counter = 49) then
                counter    <= 0;
                clk_500khz <= not clk_500khz;
            else
                counter <= counter + 1;
            end if;
        end if;

    end process clk_div;

end architecture rtl;
