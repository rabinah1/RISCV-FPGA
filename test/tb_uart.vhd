library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.uart_package.all;

entity tb_uart is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_uart;

architecture tb of tb_uart is

    signal   clk                     : std_logic := '0';
    signal   reset                   : std_logic := '0';
    signal   data_in                 : std_logic := '0';
    signal   data_from_reg_file      : std_logic_vector(31 downto 0) := (others => '0');
    signal   address_from_reg_file   : std_logic_vector(5 downto 0) := (others => '0');
    signal   reg_dump_start          : std_logic := '0';
    signal   data_out                : std_logic := '0';
    signal   halt                    : std_logic := '0';
    signal   write_trig              : std_logic := '0';
    signal   write_done              : std_logic := '0';
    signal   trig_reg_dump           : std_logic := '0';
    signal   data_to_imem            : std_logic_vector(31 downto 0) := (others => '0');
    signal   address                 : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig               : natural := 0;
    constant CLK_PERIOD              : time := 2 us;
    constant RX_REG_DUMP_WAIT_CYCLES : integer := 500000;

    component uart is
        port (
            clk                   : in    std_logic;
            reset                 : in    std_logic;
            data_in               : in    std_logic;
            data_from_reg_file    : in    std_logic_vector(31 downto 0);
            address_from_reg_file : in    std_logic_vector(5 downto 0);
            reg_dump_start        : in    std_logic;
            data_out              : out   std_logic;
            halt                  : out   std_logic;
            write_trig            : out   std_logic;
            write_done            : out   std_logic;
            trig_reg_dump         : out   std_logic;
            data_to_imem          : out   std_logic_vector(31 downto 0);
            address               : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    uart_instance : component uart
        port map (
            clk                   => clk,
            reset                 => reset,
            data_in               => data_in,
            data_from_reg_file    => data_from_reg_file,
            address_from_reg_file => address_from_reg_file,
            reg_dump_start        => reg_dump_start,
            data_out              => data_out,
            halt                  => halt,
            write_trig            => write_trig,
            write_done            => write_done,
            trig_reg_dump         => trig_reg_dump,
            data_to_imem          => data_to_imem,
            address               => address
        );

    clk_process : process is
    begin

        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;

        if (check_sig = 1) then
            wait;
        end if;

    end process clk_process;

    test_runner : process is

        alias imem_idx              is <<signal .tb_uart.uart_instance.imem_idx: integer range 0 to 4>>;
        alias rx_cycle              is <<signal .tb_uart.uart_instance.rx_cycle: integer range 0 to 78>>;
        alias packet                is <<signal .tb_uart.uart_instance.packet: std_logic_vector(7 downto 0)>>;
        alias halt_counter          is <<signal .tb_uart.uart_instance.halt_counter: integer range 0 to 100>>;
        alias rx_state              is <<signal .tb_uart.uart_instance.rx_state: state>>;
        alias reg_dump_hold_counter is <<signal .tb_uart.uart_instance.reg_dump_hold_counter:
            integer range 0 to RX_REG_DUMP_WAIT_CYCLES>>;
        alias control_byte          is <<signal .tb_uart.uart_instance.control_byte: std_logic>>;

    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_outputs_are_correct_when_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_outputs_are_correct_when_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                data_in   <= '1';
                wait for CLK_PERIOD * 2;
                check_equal(data_out, '1', "Comparing data_out against reference.");
                check_equal(halt, '0', "Comparing halt against reference.");
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(write_done, '0', "Comparing write_done against reference.");
                check_equal(trig_reg_dump, '0', "Comparing trig_reg_dump against reference.");
                check_equal(data_to_imem, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing data_to_imem against reference.");
                check_equal(address, std_logic_vector(to_unsigned(0, 32)), "Comparing address against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_idle_state_when_halt_counter_is_zero") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_idle_state_when_halt_counter_is_zero");
                info("--------------------------------------------------------------------------------");
                reset                 <= '1';
                data_in               <= '1';
                wait for CLK_PERIOD * 2;
                reset                 <= '0';
                imem_idx              <= force 0;
                halt_counter          <= force 0;
                reg_dump_hold_counter <= force RX_REG_DUMP_WAIT_CYCLES;
                rx_state              <= force idle;
                wait for CLK_PERIOD * 2;
                check_equal(halt, '0', "Comparing halt against reference.");
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(write_done, '0', "Comparing write_done against reference.");
                check_equal(address, std_logic_vector(to_unsigned(0, 32)), "Comparing address against reference.");
                check_equal(trig_reg_dump, '0', "Comparing trig_reg_dump against reference.");
                check_sig             <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_idle_state_when_halt_counter_is_above_zero_and_control_byte_is_one") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_idle_state_when_halt_counter_is_above_zero_and_control_byte_is_one");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                data_in      <= '1';
                wait for CLK_PERIOD * 2;
                reset        <= '0';
                imem_idx     <= force 0;
                halt_counter <= force 75;
                control_byte <= force '1';
                rx_state     <= force idle;
                wait for CLK_PERIOD * 2;
                check_equal(halt, '0', "Comparing halt against reference.");
                check_equal(write_done, '0', "Comparing write_done against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_idle_state_when_halt_counter_is_between_50_and_100") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_idle_state_when_halt_counter_is_between_50_and_100");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                data_in      <= '1';
                wait for CLK_PERIOD * 2;
                reset        <= '0';
                imem_idx     <= force 0;
                halt_counter <= force 75;
                control_byte <= force '0';
                rx_state     <= force idle;
                wait for CLK_PERIOD * 2;
                check_equal(halt, '1', "Comparing halt against reference.");
                check_equal(write_done, '0', "Comparing write_done against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_idle_state_when_halt_counter_is_between_0_and_50") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_idle_state_when_halt_counter_is_between_0_and_50");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                data_in      <= '1';
                wait for CLK_PERIOD * 2;
                reset        <= '0';
                imem_idx     <= force 0;
                halt_counter <= force 20;
                control_byte <= force '0';
                rx_state     <= force idle;
                wait for CLK_PERIOD * 2;
                check_equal(halt, '1', "Comparing halt against reference.");
                check_equal(write_done, '1', "Comparing write_done against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_idle_state_when_one_packet_is_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_idle_state_when_one_packet_is_read");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                data_in      <= '1';
                wait for CLK_PERIOD * 2;
                reset        <= '0';
                imem_idx     <= force 1;
                halt_counter <= force 100;
                control_byte <= force '0';
                rx_state     <= force idle;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(halt, '1', "Comparing halt against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_idle_state_when_two_packets_are_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_idle_state_when_two_packets_are_read");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                data_in      <= '1';
                wait for CLK_PERIOD * 2;
                reset        <= '0';
                imem_idx     <= force 2;
                halt_counter <= force 100;
                control_byte <= force '0';
                rx_state     <= force idle;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(halt, '1', "Comparing halt against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_idle_state_when_three_packets_are_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_idle_state_when_three_packets_are_read");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                data_in      <= '1';
                wait for CLK_PERIOD * 2;
                reset        <= '0';
                imem_idx     <= force 3;
                halt_counter <= force 100;
                control_byte <= force '0';
                rx_state     <= force idle;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(halt, '1', "Comparing halt against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_idle_state_when_four_packets_are_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_idle_state_when_four_packets_are_read");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                data_in      <= '1';
                wait for CLK_PERIOD * 2;
                reset        <= '0';
                imem_idx     <= force 4;
                halt_counter <= force 100;
                control_byte <= force '0';
                rx_state     <= force idle;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '1', "Comparing write_trig against reference.");
                check_equal(halt, '1', "Comparing halt against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_start_state_when_four_packets_are_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_start_state");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                rx_state  <= force start;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_data_reception") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_data_reception");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                data_in   <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                rx_cycle  <= force 78;
                rx_state  <= force data;
                wait for CLK_PERIOD;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(packet(0), '1', "Comparing LSB of packet against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_rx_data_reception_cycle_below_threshold") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_rx_data_reception_cycle_below_threshold");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                data_in   <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                rx_cycle  <= force 45;
                rx_state  <= force data;
                wait for CLK_PERIOD;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(packet(0), '0', "Comparing LSB of packet against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
