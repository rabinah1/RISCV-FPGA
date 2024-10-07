library ieee;
use ieee.std_logic_1164.all;

entity data_memory is
    port (
        clk          : in    std_logic;
        reset        : in    std_logic;
        address      : in    std_logic_vector(31 downto 0);
        data_in      : in    std_logic_vector(31 downto 0);
        write_enable : in    std_logic;
        data_out     : out   std_logic_vector(31 downto 0)
    );
end entity data_memory;

architecture rtl of data_memory is

begin

    data_memory : process (all) is
    begin

        if (reset = '1') then
            data_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if (write_enable = '1') then
                data_out <= data_in;
            end if;
        end if;

    end process data_memory;

end architecture rtl;
