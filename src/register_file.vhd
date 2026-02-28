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

  subtype word_t is std_logic_vector(31 downto 0);

  subtype reg_addr_t is std_logic_vector(4 downto 0);

  subtype uart_addr_t is std_logic_vector(5 downto 0);

    constant NUM_REGS    : natural     := 32;
    constant ZERO_WORD   : word_t      := (others => '0');
    constant RD_ZERO     : reg_addr_t  := (others => '0');
    constant ZERO_ADDR_6 : uart_addr_t := (others => '0');

    type memory is array(NUM_REGS - 1 downto 0) of word_t;

    signal regs : memory := (others => (others => '0'));
    signal temp : std_logic;

    function to_reg_index (
        addr : reg_addr_t
    ) return natural is
    begin

        return to_integer(unsigned(addr));

    end function to_reg_index;

    function to_uart_index (
        addr : uart_addr_t
    ) return natural is
    begin

        return to_integer(unsigned(addr));

    end function to_uart_index;

begin

    register_file : process (all) is
    begin

        reg_out_1 <= regs(to_reg_index(rs1));
        reg_out_2 <= regs(to_reg_index(rs2));

        if (reset = '1' or halt = '1') then
            reg_out_1 <= ZERO_WORD;
            reg_out_2 <= ZERO_WORD;
            regs      <= (others => (others => '0'));
        elsif (falling_edge(clk)) then
            if ((write = '1') and (rd /= RD_ZERO) and (enable = '1')) then
                regs(to_reg_index(rd)) <= write_data;
            end if;
        end if;

    end process register_file;

    reg_dump_process : process (all) is

        variable addr_uart : uart_addr_t := ZERO_ADDR_6;

    begin

        if (reset = '1') then
            reg_out_uart     <= ZERO_WORD;
            address_out_uart <= ZERO_ADDR_6;
            addr_uart        := ZERO_ADDR_6;
            reg_dump_start   <= '0';
            temp             <= '0';
        elsif (trig_reg_dump = '1') then
            if (rising_edge(clk)) then
                if (to_uart_index(addr_uart) = 0) then
                    temp <= '1';
                end if;
                if ((to_uart_index(addr_uart) < NUM_REGS) and (temp = '1')) then
                    reg_dump_start   <= '1';
                    reg_out_uart     <= regs(to_uart_index(addr_uart));
                    address_out_uart <= addr_uart;
                    temp             <= '1';
                    addr_uart        := std_logic_vector(unsigned(addr_uart) + to_unsigned(1, uart_addr_t'length));
                else
                    reg_dump_start <= '0';
                    if (to_uart_index(addr_uart) >= NUM_REGS) then
                        temp <= '0';
                    end if;
                end if;
            end if;
        else
            reg_out_uart     <= ZERO_WORD;
            address_out_uart <= ZERO_ADDR_6;
            addr_uart        := ZERO_ADDR_6;
            reg_dump_start   <= '0';
            temp             <= '0';
        end if;

    end process reg_dump_process;

end architecture rtl;
