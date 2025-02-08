library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity clk_div is
    port (
        clk_in   : in    std_logic;
        reset    : in    std_logic;
        clk_1mhz : out   std_logic
    );
end entity clk_div;

architecture rtl of clk_div is

    signal counter : unsigned(5 downto 0);

begin

    clk_div : process (all) is
    begin

        if (reset = '1') then
            clk_1mhz <= '0';
            counter  <= to_unsigned(0, counter'length);
        elsif (rising_edge(clk_in)) then
            if (counter = 49) then
                counter  <= to_unsigned(0, counter'length);
                clk_1mhz <= not clk_1mhz;
            else
                counter <= counter + 1;
            end if;
        end if;

    end process clk_div;

end architecture rtl;
