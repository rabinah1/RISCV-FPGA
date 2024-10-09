library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity program_memory is
    port (
        clk             : in    std_logic;
        reset           : in    std_logic;
        test_reset      : in    std_logic;
        pc_in           : in    std_logic_vector(31 downto 0);
        instruction_reg : out   std_logic_vector(31 downto 0)
    );
end entity program_memory;

architecture rtl of program_memory is

    type memory is array(1023 downto 0) of std_logic_vector(31 downto 0);

    signal prog_mem : memory := (others => (others => '0'));

begin

    program_memory : process (all) is
    begin

        if (reset = '1') then
            instruction_reg <= (others => '0');
            prog_mem <= (others => (others => '0'));
        elsif (test_reset = '1') then
            instruction_reg <= (others => '0');
            prog_mem(0) <= std_logic_vector(to_unsigned(2, 32));
            prog_mem(1) <= std_logic_vector(to_unsigned(4, 32));
            prog_mem(2) <= std_logic_vector(to_unsigned(6, 32));
            prog_mem(3) <= std_logic_vector(to_unsigned(8, 32));
            prog_mem(4) <= std_logic_vector(to_unsigned(10, 32));
        elsif (rising_edge(clk)) then
            instruction_reg <= prog_mem(to_integer(unsigned(pc_in)));
        end if;

    end process program_memory;

end architecture rtl;
