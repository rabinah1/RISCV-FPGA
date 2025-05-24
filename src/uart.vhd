library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is
    port (
        clk          : in    std_logic;
        reset        : in    std_logic;
        data_in      : in    std_logic;
        halt         : out   std_logic;
        write_trig   : out   std_logic;
        write_done   : out   std_logic;
        data_to_imem : out   std_logic_vector(31 downto 0);
        address      : out   std_logic_vector(31 downto 0)
    );
end entity uart;

architecture rtl of uart is

    constant PACKET_SIZE             : integer := 8;
    constant PACKETS_PER_INSTRUCTION : integer := 4;
    constant CYCLES_PER_SAMPLE       : integer := 52;
    constant CYCLES_PER_SAMPLE_FIRST : integer := 78;
    signal   start_bit_detected      : std_logic;
    signal   is_idle                 : std_logic;
    signal   packet                  : std_logic_vector(7 downto 0);
    signal   cycle                   : integer range 0 to 78 := 0;
    signal   imem_idx                : integer range 0 to 4 := 0;
    signal   increment_address       : std_logic;
    signal   first_bit               : std_logic;
    signal   halt_counter            : integer := 0;

begin

    rx : process (all) is

        variable bit_idx : integer range 0 to 8 := 0;

    begin

        if (reset = '1') then
            data_to_imem       <= (others => '0');
            address            <= (others => '0');
            write_trig         <= '0';
            halt               <= '0';
            start_bit_detected <= '0';
            is_idle            <= '1';
            packet             <= (others => '0');
            cycle              <= 0;
            bit_idx            := 0;
            imem_idx           <= 0;
            increment_address  <= '0';
            first_bit          <= '1';
            halt_counter       <= 0;
            write_done         <= '0';
        elsif (rising_edge(clk)) then
            if (is_idle = '1' and data_in = '1') then  -- idling
                start_bit_detected <= '0';
                is_idle            <= '1';
                cycle              <= 0;
                bit_idx            := 0;
                first_bit          <= '1';
                if (imem_idx = 4) then
                    imem_idx          <= 0;
                    write_trig        <= '1';
                    increment_address <= '1';
                end if;
                if (halt_counter < 100) then
                    halt         <= '1';
                    halt_counter <= halt_counter + 1;
                    if (halt_counter > 50) then
                        write_done <= '1';
                    end if;
                else
                    halt       <= '0';
                    write_trig <= '0';
                    write_done <= '0';
                    address    <= (others => '0');
                end if;
            elsif (is_idle = '1' and data_in = '0') then  -- start bit
                start_bit_detected <= '1';
                is_idle            <= '0';
                cycle              <= 0;
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
                    if (cycle < CYCLES_PER_SAMPLE_FIRST) then
                        cycle <= cycle + 1;
                    else
                        cycle           <= 0;
                        packet(bit_idx) <= data_in;
                        bit_idx         := bit_idx + 1;
                        first_bit       <= '0';
                    end if;
                else
                    if (cycle < CYCLES_PER_SAMPLE) then
                        cycle <= cycle + 1;
                    else
                        cycle           <= 0;
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
                if (cycle < CYCLES_PER_SAMPLE) then
                    cycle   <= cycle + 1;
                    is_idle <= '0';
                else
                    cycle   <= 0;
                    is_idle <= '1';
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

    end process rx;

end architecture rtl;
