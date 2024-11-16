library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

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

    type memory is array(1023 downto 0) of std_logic_vector(31 downto 0);

    signal data_mem : memory := (others => (others => '0'));

begin

    data_memory : process (all) is
    begin

        data_out <= data_mem(to_integer(unsigned(address)));

        if (reset = '1') then
            data_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if (write_enable = '1') then
                data_mem(to_integer(unsigned(address))) <= data_in;
            end if;
        end if;

    end process data_memory;

end architecture rtl;
