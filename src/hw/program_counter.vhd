library ieee;
use ieee.std_logic_1164.all;

entity program_counter is
    port (
        clk         : in    std_logic;
        reset       : in    std_logic;
        enable      : in    std_logic;
        address_in  : in    std_logic_vector(31 downto 0);
        halt        : in    std_logic;
        address_out : out   std_logic_vector(31 downto 0)
    );
end entity program_counter;

architecture rtl of program_counter is

begin

    program_counter : process (all) is
    begin

        if (reset = '1' or halt = '1') then
            address_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                address_out <= address_in;
            end if;
        end if;

    end process program_counter;

end architecture rtl;
