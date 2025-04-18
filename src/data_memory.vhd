library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
    port (
        clk          : in    std_logic;
        reset        : in    std_logic;
        address      : in    std_logic_vector(31 downto 0);
        write_data   : in    std_logic_vector(31 downto 0);
        write_enable : in    std_logic;
        output       : out   std_logic_vector(31 downto 0)
    );
end entity data_memory;

architecture rtl of data_memory is

    type memory is array(1023 downto 0) of std_logic_vector(31 downto 0);

    signal data_mem : memory := (others => (others => '0'));

begin

    data_memory : process (all) is
    begin

        output <= data_mem(to_integer(unsigned(address(9 downto 0))));

        if (reset = '1') then
            output <= (others => '0');
        elsif (rising_edge(clk)) then
            if (write_enable = '1') then
                data_mem(to_integer(unsigned(address(9 downto 0)))) <= write_data;
            end if;
        end if;

    end process data_memory;

end architecture rtl;
