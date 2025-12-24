library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        clk              : in    std_logic;
        reset            : in    std_logic;
        enable           : in    std_logic;
        rs1              : in    std_logic_vector(4 downto 0);
        rs2              : in    std_logic_vector(4 downto 0);
        rd               : in    std_logic_vector(4 downto 0);
        write            : in    std_logic;
        write_data       : in    std_logic_vector(31 downto 0);
        trig_reg_dump    : in    std_logic;
        halt             : in    std_logic;
        reg_out_1        : out   std_logic_vector(31 downto 0);
        reg_out_2        : out   std_logic_vector(31 downto 0);
        reg_out_uart     : out   std_logic_vector(31 downto 0);
        address_out_uart : out   std_logic_vector(5 downto 0);
        reg_dump_start   : out   std_logic
    );
end entity register_file;

architecture rtl of register_file is

    type memory is array(31 downto 0) of std_logic_vector(31 downto 0);

    signal regs : memory := (others => (others => '0'));
    signal temp : std_logic;

begin

    register_file : process (all) is
    begin

        reg_out_1 <= regs(to_integer(unsigned(rs1)));
        reg_out_2 <= regs(to_integer(unsigned(rs2)));

        if (reset = '1' or halt = '1') then
            reg_out_1 <= (others => '0');
            reg_out_2 <= (others => '0');
            regs      <= (others => (others => '0'));
        elsif (falling_edge(clk)) then
            if (write = '1' and rd /= "00000" and enable = '1') then
                regs(to_integer(unsigned(rd))) <= write_data;
            end if;
        end if;

    end process register_file;

    reg_dump_process : process (all) is

        variable addr_uart : std_logic_vector(5 downto 0) := (others => '0');

    begin

        if (reset = '1') then
            reg_out_uart     <= (others => '0');
            address_out_uart <= (others => '0');
            addr_uart        := (others => '0');
            reg_dump_start   <= '0';
            temp             <= '0';
        elsif (trig_reg_dump = '1') then
            if (rising_edge(clk)) then
                if (to_integer(unsigned(addr_uart)) = 0) then
                    temp <= '1';
                end if;
                if (to_integer(unsigned(addr_uart)) < 32 and temp = '1') then
                    reg_dump_start   <= '1';
                    reg_out_uart     <= regs(to_integer(unsigned(addr_uart)));
                    address_out_uart <= addr_uart;
                    temp             <= '1';
                    addr_uart        := std_logic_vector(unsigned(addr_uart) + to_unsigned(1, 5));
                else
                    reg_dump_start <= '0';
                    if (to_integer(unsigned(addr_uart)) >= 32) then
                        temp <= '0';
                    end if;
                end if;
            end if;
        else
            reg_out_uart     <= (others => '0');
            address_out_uart <= (others => '0');
            addr_uart        := (others => '0');
            reg_dump_start   <= '0';
            temp             <= '0';
        end if;

    end process reg_dump_process;

end architecture rtl;
