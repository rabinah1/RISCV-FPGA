library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.uart_package.all;

entity uart is
    port (
        clk               : in    std_logic;
        reset             : in    std_logic;
        data_in           : in    std_logic;
        data_from_imem    : in    std_logic_vector(31 downto 0);
        address_from_imem : in    std_logic_vector(5 downto 0);
        reg_dump_start    : in    std_logic;
        data_out          : out   std_logic;
        halt              : out   std_logic;
        write_trig        : out   std_logic;
        write_done        : out   std_logic;
        trig_reg_dump     : out   std_logic;
        data_to_imem      : out   std_logic_vector(31 downto 0);
        address           : out   std_logic_vector(31 downto 0)
    );
end entity uart;

architecture rtl of uart is

    type memory is array(31 downto 0) of std_logic_vector(31 downto 0);

    constant PACKET_SIZE             : integer := 8;
    constant PACKETS_PER_INSTRUCTION : integer := 4;
    constant CYCLES_PER_SAMPLE       : integer := 52;
    constant CYCLES_PER_SAMPLE_FIRST : integer := 78;
    signal   start_bit_detected      : std_logic;
    signal   is_idle                 : std_logic;
    signal   packet                  : std_logic_vector(7 downto 0);
    signal   rx_cycle                : integer range 0 to CYCLES_PER_SAMPLE_FIRST := 0;
    signal   tx_cycle                : integer range 0 to CYCLES_PER_SAMPLE := 0;
    signal   imem_idx                : integer range 0 to 4 := 0;
    signal   increment_address       : std_logic;
    signal   first_bit               : std_logic;
    signal   halt_counter            : integer := 0;
    signal   trig_uart_tx            : std_logic;
    signal   first_byte              : std_logic;
    signal   regs                    : memory := (others => (others => '0'));
    signal   state                   : tx_state;
    signal   next_state              : tx_state;
    signal   delay_counter           : integer := 0;
    signal   reg_dump_hold_counter   : integer := 0;

begin

    rx : process (all) is

        variable bit_idx : integer range 0 to 8 := 0;

    begin

        if (reset = '1') then
            data_to_imem          <= (others => '0');
            address               <= (others => '0');
            write_trig            <= '0';
            halt                  <= '0';
            start_bit_detected    <= '0';
            is_idle               <= '1';
            packet                <= (others => '0');
            rx_cycle              <= 0;
            bit_idx               := 0;
            imem_idx              <= 0;
            increment_address     <= '0';
            first_bit             <= '1';
            halt_counter          <= 100;
            write_done            <= '0';
            first_byte            <= '1';
            trig_reg_dump         <= '0';
            delay_counter         <= 0;
            reg_dump_hold_counter <= 0;
        elsif (rising_edge(clk)) then
            if (is_idle = '1' and data_in = '1') then  -- idling
                start_bit_detected <= '0';
                is_idle            <= '1';
                rx_cycle           <= 0;
                bit_idx            := 0;
                first_bit          <= '1';
                if (imem_idx = PACKETS_PER_INSTRUCTION) then
                    imem_idx          <= 0;
                    write_trig        <= '1';
                    increment_address <= '1';
                end if;
                if (halt_counter < 100) then
                    if (first_byte = '0') then
                        halt <= '1';
                    end if;
                    halt_counter <= halt_counter + 1;
                    if (halt_counter > 50 and first_byte = '0') then
                        write_done <= '1';
                    end if;
                else
                    halt       <= '0';
                    write_trig <= '0';
                    write_done <= '0';
                    first_byte <= '1';
                    packet     <= (others => '0');
                    if (reg_dump_hold_counter < 500000) then
                        reg_dump_hold_counter <= reg_dump_hold_counter + 1;
                    else
                        trig_reg_dump <= '0';
                    end if;
                    delay_counter <= 0;
                    address       <= (others => '0');
                end if;
            elsif (is_idle = '1' and data_in = '0') then  -- start bit
                start_bit_detected <= '1';
                is_idle            <= '0';
                rx_cycle           <= 0;
                bit_idx            := 0;
                write_trig         <= '0';
                first_bit          <= '1';
                halt_counter       <= 0;
                if (increment_address = '1') then
                    address           <= std_logic_vector(unsigned(address) + to_unsigned(1, 32));
                    increment_address <= '0';
                end if;
            elsif (start_bit_detected = '1' and bit_idx < PACKET_SIZE) then
                -- data frame after start bit
                write_trig         <= '0';
                start_bit_detected <= '1';
                is_idle            <= '0';
                increment_address  <= '0';
                halt_counter       <= 0;
                if (first_bit = '1') then
                    if (rx_cycle < CYCLES_PER_SAMPLE_FIRST) then
                        rx_cycle <= rx_cycle + 1;
                    else
                        rx_cycle        <= 0;
                        packet(bit_idx) <= data_in;
                        bit_idx         := bit_idx + 1;
                        first_bit       <= '0';
                    end if;
                else
                    if (rx_cycle < CYCLES_PER_SAMPLE) then
                        rx_cycle <= rx_cycle + 1;
                    else
                        rx_cycle        <= 0;
                        packet(bit_idx) <= data_in;
                        bit_idx         := bit_idx + 1;
                    end if;
                end if;
            else -- after data frame has been processed (stop bit)
                write_trig         <= '0';
                bit_idx            := 0;
                start_bit_detected <= '0';
                increment_address  <= '0';
                halt_counter       <= 0;
                if (rx_cycle < CYCLES_PER_SAMPLE) then
                    rx_cycle <= rx_cycle + 1;
                    is_idle  <= '0';
                else
                    if (first_byte = '1') then
                        if (packet = "00000001") then
                            if (delay_counter < 500000) then
                                delay_counter <= delay_counter + 1;
                            else
                                rx_cycle              <= 0;
                                is_idle               <= '1';
                                trig_reg_dump         <= '1';
                                reg_dump_hold_counter <= 0;
                                first_byte            <= '1';
                            end if;
                        else
                            trig_reg_dump <= '0';
                            first_byte    <= '0';
                            rx_cycle      <= 0;
                            is_idle       <= '1';
                        end if;
                    else
                        rx_cycle <= 0;
                        is_idle  <= '1';
                        if (imem_idx = 0) then
                            data_to_imem(7 downto 0) <= packet;
                            imem_idx                 <= 1;
                        elsif (imem_idx = 1) then
                            data_to_imem(15 downto 8) <= packet;
                            imem_idx                  <= 2;
                        elsif (imem_idx = 2) then
                            data_to_imem(23 downto 16) <= packet;
                            imem_idx                   <= 3;
                        elsif (imem_idx = 3) then
                            data_to_imem(31 downto 24) <= packet;
                            imem_idx                   <= 4;
                        end if;
                    end if;
                end if;
            end if;
        end if;

    end process rx;

    tx_state_change : process (clk, reset) is
    begin

        if (reset = '1') then
            state <= idle;
        elsif (falling_edge(clk)) then
            state <= next_state;
        end if;

    end process tx_state_change;

    tx_state_machine : process (all) is

        variable bit_idx  : integer := 0;
        variable reg_idx  : integer := 0;
        variable byte_idx : integer := 0;

    begin

        if (reset = '1') then
            data_out   <= '1';
            tx_cycle   <= 0;
            bit_idx    := 0;
            reg_idx    := 0;
            byte_idx   := 0;
            next_state <= idle;
        elsif (rising_edge(clk)) then

            case state is

                when idle =>

                    data_out <= '1';
                    if (trig_uart_tx = '1') then
                        next_state <= start;
                    else
                        next_state <= idle;
                    end if;

                when start =>

                    data_out <= '0';
                    if (tx_cycle < CYCLES_PER_SAMPLE) then
                        tx_cycle   <= tx_cycle + 1;
                        next_state <= start;
                    else
                        tx_cycle   <= 0;
                        next_state <= data;
                    end if;

                when data =>

                    if (bit_idx < PACKET_SIZE * (byte_idx + 1)) then
                        if (tx_cycle < CYCLES_PER_SAMPLE) then
                            data_out   <= regs(reg_idx)(bit_idx);
                            tx_cycle   <= tx_cycle + 1;
                            next_state <= data;
                        else
                            tx_cycle   <= 0;
                            bit_idx    := bit_idx + 1;
                            next_state <= data;
                        end if;
                    else
                        byte_idx   := byte_idx + 1;
                        tx_cycle   <= 0;
                        next_state <= stop;
                    end if;

                when stop =>

                    data_out <= '1';
                    if (tx_cycle < CYCLES_PER_SAMPLE) then
                        tx_cycle   <= tx_cycle + 1;
                        next_state <= stop;
                    else
                        if (byte_idx = 4) then
                            byte_idx := 0;
                            reg_idx  := reg_idx + 1;
                            bit_idx  := 0;
                        end if;
                        tx_cycle <= 0;
                        if (reg_idx > 31) then
                            next_state <= idle;
                            reg_idx    := 0;
                        else
                            next_state <= start;
                        end if;
                    end if;

            end case;

        end if;

    end process tx_state_machine;

    reg_dump_process : process (all) is
    begin

        if (reset = '1') then
            regs         <= (others => (others => '0'));
            trig_uart_tx <= '0';
        elsif (falling_edge(clk)) then
            if (reg_dump_start = '1') then
                regs(to_integer(unsigned(address_from_imem))) <= data_from_imem;
                if (to_integer(unsigned(address_from_imem)) > 29) then
                    trig_uart_tx <= '1';
                end if;
            else
                trig_uart_tx <= '0';
            end if;
        end if;

    end process reg_dump_process;

end architecture rtl;
