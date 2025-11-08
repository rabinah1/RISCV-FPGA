library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_memory is
    port (
        clk             : in    std_logic;
        reset           : in    std_logic;
        fetch_enable    : in    std_logic;
        write_trig      : in    std_logic;
        halt            : in    std_logic;
        write_done      : in    std_logic;
        byte_from_uart  : in    std_logic_vector(31 downto 0);
        uart_address_in : in    std_logic_vector(31 downto 0);
        address_in      : in    std_logic_vector(31 downto 0);
        address_out     : out   std_logic_vector(31 downto 0);
        instruction     : out   std_logic_vector(31 downto 0)
    );
end entity program_memory;

architecture rtl of program_memory is

    constant PROGRAM_MEMORY_SIZE : integer := 512;

    type memory is array(PROGRAM_MEMORY_SIZE - 1 downto 0) of std_logic_vector(31 downto 0);

    signal prog_mem : memory := (others => (others => '0'));

begin

    program_memory : process (all) is
    begin

        if (reset = '1') then
            instruction <= (others => '0');
            address_out <= (others => '0');
            prog_mem    <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            if (halt = '1') then
                instruction <= (others => '0');
                address_out <= (others => '0');
                if (write_done = '1') then
                    prog_mem(511 downto to_integer(unsigned(uart_address_in)) + 1) <= (others => (others => '0'));
                end if;
            elsif (fetch_enable = '1') then
                instruction <= prog_mem(to_integer(unsigned(address_in(9 downto 0))));
                address_out <= address_in;
            end if;
            if (write_trig = '1') then
                prog_mem(to_integer(unsigned(uart_address_in))) <= byte_from_uart;
            end if;
        end if;

    end process program_memory;

end architecture rtl;
