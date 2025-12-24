library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
    port (
        clk               : in    std_logic;
        reset             : in    std_logic;
        address_bytes     : in    std_logic_vector(31 downto 0);
        write_data        : in    std_logic_vector(31 downto 0);
        write_enable      : in    std_logic;
        load_enable       : in    std_logic;
        write_back_enable : in    std_logic;
        halt              : in    std_logic;
        mem_access_err    : out   std_logic;
        output            : out   std_logic_vector(31 downto 0)
    );
end entity data_memory;

architecture rtl of data_memory is

    constant DATA_MEMORY_SIZE_WORDS : integer := 1600;

    type memory is array(DATA_MEMORY_SIZE_WORDS - 1 downto 0) of std_logic_vector(31 downto 0);

    signal data_mem : memory := (others => (others => '0'));

begin

    read_process : process (all) is

        variable address_words : std_logic_vector(31 downto 0) := (others => '0');

    begin

        if (reset = '1' or halt = '1') then
            mem_access_err <= '0';
            output         <= (others => '0');
            address_words  := (others => '0');
        elsif (load_enable = '1') then
            address_words := "00" & address_bytes(31 downto 2);
            if (to_integer(unsigned(address_words)) >= DATA_MEMORY_SIZE_WORDS and write_back_enable = '1') then
                mem_access_err <= '1';
                output         <= (others => '0');
            else
                output <= data_mem(to_integer(unsigned(address_words)));
            end if;
        else
            output <= (others => '0');
        end if;

    end process read_process;

    write_process : process (all) is

        variable address_words : std_logic_vector(31 downto 0) := (others => '0');

    begin

        if (reset = '1' or halt = '1') then
            data_mem      <= (others => (others => '0'));
            address_words := (others => '0');
        elsif (rising_edge(clk)) then
            address_words := "00" & address_bytes(31 downto 2);
            if (write_enable = '1' and write_back_enable = '1' and mem_access_err = '0') then
                data_mem(to_integer(unsigned(address_words))) <= write_data;
            end if;
        end if;

    end process write_process;

end architecture rtl;
