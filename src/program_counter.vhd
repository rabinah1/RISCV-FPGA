library ieee;
use ieee.std_logic_1164.all;

entity program_counter is
    port (
        clk           : in    std_logic;
        reset         : in    std_logic;
        start_program : in    std_logic;
        address_in    : in    std_logic_vector(31 downto 0);
        address_out   : out   std_logic_vector(31 downto 0)
    );
end entity program_counter;

architecture rtl of program_counter is

begin

    program_counter : process (all) is
    begin

        if (reset = '1' or start_program = '0') then
            address_out <= (others => '0');
        elsif (rising_edge(clk)) then
            address_out <= address_in;
        end if;

    end process program_counter;

end architecture rtl;
