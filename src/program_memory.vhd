library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_memory is
    port (
        clk                    : in    std_logic;
        reset                  : in    std_logic;
        fetch_enable           : in    std_logic;
        write_trig             : in    std_logic;
        halt                   : in    std_logic;
        data_word_from_uart    : in    std_logic_vector(31 downto 0);
        address_word_from_uart : in    std_logic_vector(31 downto 0);
        address_in             : in    std_logic_vector(31 downto 0);
        address_out            : out   std_logic_vector(31 downto 0);
        instruction            : out   std_logic_vector(31 downto 0)
    );
end entity program_memory;

architecture rtl of program_memory is

    constant PROGRAM_MEMORY_SIZE_WORDS : integer := 4096;

    type memory is array(PROGRAM_MEMORY_SIZE_WORDS - 1 downto 0) of std_logic_vector(31 downto 0);

    signal prog_mem : memory := (others => (others => '0'));

begin

    program_memory : process (all) is
    begin

        if (reset = '1') then
            instruction <= (others => '0');
            address_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if (halt = '1') then
                instruction <= (others => '0');
                address_out <= (others => '0');
            elsif (fetch_enable = '1') then
                instruction <= prog_mem(to_integer(unsigned(address_in)));
                address_out <= address_in;
            end if;
            if (write_trig = '1') then
                prog_mem(to_integer(unsigned(address_word_from_uart))) <= data_word_from_uart;
            end if;
        end if;

    end process program_memory;

end architecture rtl;
