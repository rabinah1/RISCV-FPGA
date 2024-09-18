library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity register_file is
    port (
        clk : in std_logic;
        reset : in std_logic;
        rs1 : in std_logic_vector(4 downto 0);
        rs2 : in std_logic_vector(4 downto 0);
        rd : in std_logic_vector(4 downto 0);
        write : in std_logic;
        write_data : in std_logic_vector(31 downto 0);
        reg_out_1 : out std_logic_vector(31 downto 0);
        reg_out_2 : out std_logic_vector(31 downto 0)
    );
end entity register_file;

architecture rtl of register_file is

    type memory is array(31 downto 0) of std_logic_vector(31 downto 0);

    signal regs : memory;

begin

    register_file : process (all) is
    begin

        if (reset = '1') then
            regs <= (others => (others => '0'));
            reg_out_1 <= (others => '0');
            reg_out_2 <= (others => '0');
        elsif (rising_edge(clk)) then
            reg_out_1 <= regs(to_integer(unsigned(rs1)));
            reg_out_2 <= regs(to_integer(unsigned(rs2)));
        end if;

    end process register_file;

end architecture rtl;
