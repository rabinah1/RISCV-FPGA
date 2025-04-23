library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_uart is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_uart;

architecture tb of tb_uart is

    signal   clk           : std_logic := '0';
    signal   reset         : std_logic := '0';
    signal   data_in       : std_logic := '0';
    signal   start_program : std_logic := '0';
    signal   write_trig    : std_logic := '0';
    signal   data_to_imem  : std_logic_vector(31 downto 0) := (others => '0');
    signal   address       : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig     : natural := 0;
    constant CLK_PERIOD    : time := 2 us;

    component uart is
        port (
            clk           : in    std_logic;
            reset         : in    std_logic;
            data_in       : in    std_logic;
            start_program : in    std_logic;
            write_trig    : out   std_logic;
            data_to_imem  : out   std_logic_vector(31 downto 0);
            address       : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    uart_instance : component uart
        port map (
            clk           => clk,
            reset         => reset,
            data_in       => data_in,
            start_program => start_program,
            write_trig    => write_trig,
            data_to_imem  => data_to_imem,
            address       => address
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

        alias is_idle            is <<signal .tb_uart.uart_instance.is_idle: std_logic>>;
        alias imem_idx           is <<signal .tb_uart.uart_instance.imem_idx: integer range 0 to 4>>;
        alias increment_address  is <<signal .tb_uart.uart_instance.increment_address: std_logic>>;
        alias start_bit_detected is <<signal .tb_uart.uart_instance.start_bit_detected: std_logic>>;
        alias cycle              is <<signal .tb_uart.uart_instance.cycle: integer range 0 to 78>>;
        alias first_bit          is <<signal .tb_uart.uart_instance.first_bit: std_logic>>;
        alias packet             is <<signal .tb_uart.uart_instance.packet: std_logic_vector(7 downto 0)>>;

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
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(data_to_imem, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing data_to_imem against reference.");
                check_equal(address, std_logic_vector(to_unsigned(0, 32)), "Comparing address against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_idle_state_when_zero_packets_are_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_idle_state_when_zero_packets_are_read");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                data_in   <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                is_idle   <= force '1';
                imem_idx  <= force 0;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '0', "Comparing result against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_idle_state_when_one_packet_is_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_idle_state_when_one_packet_is_read");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                data_in   <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                is_idle   <= force '1';
                imem_idx  <= force 1;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '0', "Comparing result against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_idle_state_when_two_packets_are_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_idle_state_when_two_packets_are_read");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                data_in   <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                is_idle   <= force '1';
                imem_idx  <= force 2;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '0', "Comparing result against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_idle_state_when_three_packets_are_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_idle_state_when_three_packets_are_read");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                data_in   <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                is_idle   <= force '1';
                imem_idx  <= force 3;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '0', "Comparing result against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_idle_state_when_four_packets_are_read") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_idle_state_when_four_packets_are_read");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                data_in   <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                is_idle   <= force '1';
                imem_idx  <= force 4;
                wait for CLK_PERIOD * 2;
                check_equal(write_trig, '1', "Comparing result against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_start_bit_detected_no_address_change") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_start_bit_detected_no_address_change");
                info("--------------------------------------------------------------------------------");
                reset             <= '1';
                data_in           <= '0';
                wait for CLK_PERIOD * 2;
                reset             <= '0';
                is_idle           <= force '1';
                increment_address <= force '0';
                wait for CLK_PERIOD * 2;
                check_equal(address, std_logic_vector(to_unsigned(0, 32)), "Comparing address against reference.");
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_sig         <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_start_bit_detected_with_address_change") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_start_bit_detected_with_address_change");
                info("--------------------------------------------------------------------------------");
                reset             <= '1';
                data_in           <= '0';
                wait for CLK_PERIOD * 2;
                reset             <= '0';
                is_idle           <= force '1';
                increment_address <= force '1';
                wait for CLK_PERIOD;
                check_equal(address, std_logic_vector(to_unsigned(1, 32)), "Comparing address against reference.");
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_sig         <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_data_reception_first_bit") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_data_reception_first_bit");
                info("--------------------------------------------------------------------------------");
                reset              <= '1';
                data_in            <= '1';
                wait for CLK_PERIOD * 2;
                reset              <= '0';
                is_idle            <= force '0';
                start_bit_detected <= force '1';
                cycle              <= force 78;
                first_bit          <= force '1';
                wait for CLK_PERIOD;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(packet(0), '1', "Comparing LSB of packet against reference.");
                check_sig          <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_data_reception_after_first_bit") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_data_reception_after_first_bit");
                info("--------------------------------------------------------------------------------");
                reset              <= '1';
                data_in            <= '1';
                wait for CLK_PERIOD * 2;
                reset              <= '0';
                is_idle            <= force '0';
                start_bit_detected <= force '1';
                cycle              <= force 52;
                first_bit          <= force '0';
                wait for CLK_PERIOD;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(packet(0), '1', "Comparing LSB of packet against reference.");
                check_sig          <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_stop_bit_first_packet") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_stop_bit_first_packet");
                info("--------------------------------------------------------------------------------");
                reset              <= '1';
                data_in            <= '0';
                wait for CLK_PERIOD * 2;
                reset              <= '0';
                is_idle            <= force '0';
                start_bit_detected <= force '0';
                cycle              <= force 52;
                packet             <= force "00110101";
                imem_idx           <= force 0;
                wait for CLK_PERIOD;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(data_to_imem, std_logic_vector(unsigned'("00000000000000000000000000110101")),
                            "Comparing data_to_imem against reference.");
                check_sig          <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_stop_bit_second_packet") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_stop_bit_second_packet");
                info("--------------------------------------------------------------------------------");
                reset              <= '1';
                data_in            <= '0';
                wait for CLK_PERIOD * 2;
                reset              <= '0';
                is_idle            <= force '0';
                start_bit_detected <= force '0';
                cycle              <= force 52;
                packet             <= force "00110101";
                imem_idx           <= force 1;
                wait for CLK_PERIOD;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(data_to_imem, std_logic_vector(unsigned'("00000000000000000011010100000000")),
                            "Comparing data_to_imem against reference.");
                check_sig          <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_stop_bit_third_packet") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_stop_bit_third_packet");
                info("--------------------------------------------------------------------------------");
                reset              <= '1';
                data_in            <= '0';
                wait for CLK_PERIOD * 2;
                reset              <= '0';
                is_idle            <= force '0';
                start_bit_detected <= force '0';
                cycle              <= force 52;
                packet             <= force "00110101";
                imem_idx           <= force 2;
                wait for CLK_PERIOD;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(data_to_imem, std_logic_vector(unsigned'("00000000001101010000000000000000")),
                            "Comparing data_to_imem against reference.");
                check_sig          <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_stop_bit_fourth_packet") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_stop_bit_fourth_packet");
                info("--------------------------------------------------------------------------------");
                reset              <= '1';
                data_in            <= '0';
                wait for CLK_PERIOD * 2;
                reset              <= '0';
                is_idle            <= force '0';
                start_bit_detected <= force '0';
                cycle              <= force 52;
                packet             <= force "00110101";
                imem_idx           <= force 3;
                wait for CLK_PERIOD;
                check_equal(write_trig, '0', "Comparing write_trig against reference.");
                check_equal(data_to_imem, std_logic_vector(unsigned'("00110101000000000000000000000000")),
                            "Comparing data_to_imem against reference.");
                check_sig          <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
